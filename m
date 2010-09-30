Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0I3Hiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:38:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46851 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0I3Hiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:38:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ec9C0wgRUwQr9EugRmBDQY2mT5Hzk8nJC8rBaTQnHwW+9mf+8iqXV8pXA5nipGLjlQ
         UXNIlydMjd1EgcfsI0LxQ14B5jOu7oFEoVlum6LafR6jNngnfjfQXQraPQImaIHeyXAz
         5xz/KHUqaFdgO76etFh31X6xO0r5fmBxUmANs=
Date: Thu, 30 Sep 2010 03:38:49 -0400
From: tmhikaru@gmail.com
To: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.35.6
Message-ID: <20100930073849.GA22671@roll>
References: <20100927163208.GA4892@roll> <20100927215135.3d11d587@schatten.dmk.lab> <20100927233956.GA15705@roll> <20100928083505.0a808ffd@schatten.dmk.lab> <20100928190358.GA24303@roll> <20100929092924.2090f19e@schatten.dmk.lab> <20100929110247.GA2032@roll> <20100929135248.09cd7a84@schatten.dmk.lab> <20100930013305.GA23569@roll> <20100930072927.77f0f79b@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20100930072927.77f0f79b@schatten.dmk.lab>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2010 at 07:29:27AM +0200, Florian Mickler wrote:

> git-log is not that expressive here, as it only shows the history of
> current HEAD (the currently checked out version). You can post the
> output of 'git bisect log'.=20
> If you wanna know how the region looks like you can type 'git bisect
> visualize'.=20

Wow that's neat. I can't be sure I understand exactly what its saying but if
I'm looking at it right I'm in the middle of a temporary fork that was
created just after 2.6.34-rc6 and was merged with 2.6.35-rc1.

This is what my git bisect log looks like:

tm@roll:~/src/linux-2.6$ git bisect log
git bisect start
# good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
# bad: [9fe6206f400646a2322096b56c59891d530e8d51] Linux 2.6.35
git bisect bad 9fe6206f400646a2322096b56c59891d530e8d51
# skip: [e0bc5d4a54938eedcde14005210e6c08aa9727e4] Merge branch 'i2c-for-li=
nus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging
git bisect skip e0bc5d4a54938eedcde14005210e6c08aa9727e4
# good: [c72ea83d39efa71bf0e3fc1125e780071a79f1bc] e1000e: Remove unnessary=
 log message
git bisect good c72ea83d39efa71bf0e3fc1125e780071a79f1bc
# skip: [4403158ba295c8e36f6736b1bb12d0f7e1923dac] Ban ecryptfs over ecrypt=
fs
git bisect skip 4403158ba295c8e36f6736b1bb12d0f7e1923dac
# bad: [c392c4c6dccf7c64c113b473c7eceedf25eddd51] Merge branch 'perf' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 into perf/core
git bisect bad c392c4c6dccf7c64c113b473c7eceedf25eddd51
# good: [f869097e884d8cb65b2bb7831ca57b7dffb66fdd] perf session: Make read_=
build_id routines look at the host_machine too
git bisect good f869097e884d8cb65b2bb7831ca57b7dffb66fdd
# bad: [b8ae30ee26d379db436b0b8c8c3ff1b52f69e5d1] Merge branch 'sched-core-=
for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-t=
ip
git bisect bad b8ae30ee26d379db436b0b8c8c3ff1b52f69e5d1
# good: [1014cfe2fb4cdd663137aafb21448cb613dd6a7d] Merge branch 'core-locki=
ng-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.=
6-tip
git bisect good 1014cfe2fb4cdd663137aafb21448cb613dd6a7d
# good: [3aaf51ace5975050ab43c7d4d7e439e0ae7d13d7] Merge branch 'oprofile-f=
or-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 3aaf51ace5975050ab43c7d4d7e439e0ae7d13d7
# good: [371fd7e7a56a5c136d31aa980011bd2f131c3ef5] sched: Add enqueue/deque=
ue flags
git bisect good 371fd7e7a56a5c136d31aa980011bd2f131c3ef5
# bad: [e7858f52a5cb868289a72264534a1f05f3340c6c] Merge branch 'cpu_stop' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc into sched/core
git bisect bad e7858f52a5cb868289a72264534a1f05f3340c6c

Just a few more steps until we find the culprit, it said 7 revisions
remained after this bisect.

Tim McGrath

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKQ+iZEncCrqzVruAQKOvwgAng9h1puq92qHwwuxXCEaOwwUTH1S/EuO
ts2Vhl2BJoOj7CJLvhbeHuj5cwBqVGUDF/+cEu9Oe4GV2hxXNUWiId8oifS5paPN
bZd73ehfctJBq3iYgApOoKNQO6vhhq27dH6yx03qwugm+7cQU3adD8wlW/IJ3Tvk
ATmXFlz1lmDjkCdzmGS50KfqBj7v3FWKvhEWXt11Oi/qJP5gkIbfA1C8ogiN5oTF
+t65lPt6CBLK/Kpibpr27LhJMllUUP3rL90i2rioqSNzndJLE93Ti7RU8kNSSe3S
SFWDmSrHDunmIaxaOTmQSuKrSJy7p0b67BfsJdNivpZN9in73HvfNA==
=G5eV
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
