Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab2LLAoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:44:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53364 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2LLAon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:44:43 -0500
Date: Wed, 12 Dec 2012 11:44:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        fengguang.wu@intel.com, julia.lawall@lip6.fr, jiang.liu@huawei.com
Subject: Re: [GIT PULL] VFIO updates for v3.8
Message-Id: <20121212114430.cceef241f595a95e16c48874@canb.auug.org.au>
In-Reply-To: <1355270816.3224.179.camel@bling.home>
References: <1355252887.3224.176.camel@bling.home>
	<20121212104632.b01520d6015486dd3ae507ef@canb.auug.org.au>
	<1355270816.3224.179.camel@bling.home>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Dec_2012_11_44_30_+1100_LkcJAHV/ufnvWP8K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Dec_2012_11_44_30_+1100_LkcJAHV/ufnvWP8K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Tue, 11 Dec 2012 17:06:56 -0700 Alex Williamson <alex.williamson@redhat.=
com> wrote:
>
> Is that a bad thing?  I can start tagging from my next branch if that's
> preferred.  Thanks,

Linus has said many times to not rebase before sending a pull request.
When you rebase your tree you effectively throw away your testing (since
the thing you rebased on top of may have introduced semantic conflicts
with the work in your tree).  If you don't rebase your tested tree, any
conflicts are then restricted to the actual merge and can be fixed there
(or at least the diagnosis will lead there).

So, if I was a maintiner, at the start of the merge window (or just
before) I would create a test branch that contained my work plus a
*merge* with Linus' tree and do some testing on that and then ask Linus
to pull my tree (not the merged version).  It may prove that the test
merge with Linus' tree produces an "interesting" syntactic conflict - in
this case I would mention that to Linus and put the merged tree somewhere
public for him to use as a guide.  (Mind you, this conflict would already
have most likely been noted by the linux-next maintainer.)

Also, your testing may have brought to light a semantic conflict, in
which case the fix could be supplied to Linus with the pull request, or a
well changed logged back merge of Linus' tree containing the fix could be
done and Linus asked to pull the result.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Dec_2012_11_44_30_+1100_LkcJAHV/ufnvWP8K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQx9NuAAoJEECxmPOUX5FE8mAQAJhRJKRi5em6YvS5g6N0ASL1
wiCubXrgEHR1SwLz+1eZvVueeRQPd/+H5YuSDK0cqSHWQvtZEk2HoD6S3LoLwuGV
4UJTyn8N3Z+k6WeD7R/5jV728o8ekmwQOJfvgGL/FWJE54ABqnVyrFYeFneyIqPl
s1LgKgov0JkqKFQuEjPZ9rkH68ifiJuirxYUJ4+XEsVWNFI0tfi2f0CsDTthej7B
Tn7Xlhyjw94yg4ZXPN736Mv4nqTZNzxSbET3AUEQxkJ3Ap+2qTYH/7LDzTAjShI9
ah8yQHgsztmbQnFLPeDYvJRMsy9k/J8RliDCXwyuaL2IIxaxTjyI26I85+UNDu+C
IanNeE0BHG2mVZdynQYss7yQILfzyncQ+1PrsJpAKcW8EfArxhCpmD5RYahzwPbM
HjH8fLkON0Qyuhn7ydTq6/NeHauwMJeVKx8EnmP2VHuWLQqfNRfbKCUBXNiY5Xya
7jxQBHFsG31XY5TJUrzoqzaAFS1QQK7FisdE3+4fiYgPJpzHuTX56Kfrqh83mWCj
++pmeCy8Sb1X03kuC9AazPIEaoTH32p+pMKV+mwLWVE01MBDZHPwH4fEkXYWSFgS
JOfDHXgDESFu94SMV+Dgsl9/vfEc3PefuFWEmXIkAePCHIBcA55pFO9qtfiWhNy2
lu6o8BmDHmxByZIp6uQN
=B1gT
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Dec_2012_11_44_30_+1100_LkcJAHV/ufnvWP8K--
