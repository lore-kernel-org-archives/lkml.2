Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1H2F1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:27:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47674 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1H2F1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:27:10 -0400
Date: Mon, 29 Aug 2011 15:27:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: linux-next: build warning after merge of the ptrace tree
Message-Id: <20110829152704.e533760bfb83fc7480333b20@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Aug_2011_15_27_04_+1000_34HzZs=EiWB68_6f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Aug_2011_15_27_04_+1000_34HzZs=EiWB68_6f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the ptrace tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/autofs4/waitq.c: In function 'autofs4_wait':
fs/autofs4/waitq.c:462:17: warning: unused variable 'irqflags'

Introduced by commit 33ee1d9bc213 ("autofs4: Use set_current_blocked()").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Aug_2011_15_27_04_+1000_34HzZs=EiWB68_6f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOWyMoAAoJEDMEi1NhKgbsh4sH+wcB09K7v4HWTFqQ6Lh2bOWH
KuYwJ5qnUl49o7EUwldPL5JqgTSh5oHXSVfigyFF79TQ1l4rr5rKdygw7/ZTE5f0
qBDtu/lQ3zfL/YnNmUj0gVwgrTRN4l/+NpYDKAvF8DmmUXJL6+8faDyW3Ey5sVPh
KZnAbGXt+BT8wk61891nefH18lYwhyBeRhPxjuwV+b5lZC+zR+aFginlbd2IWlAN
/88B2NxXImAllJ4f7oem9mTQJ+Sd+sVs71UrCNjTqPT9T7VSj78NL6idZMPS78kY
p+XVXCpXZ9afjUOOTdZJht0UoVtPIHzxMG4YpM6HgduOLk/rj85isIfOBVvOsoQ=
=6ahb
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Aug_2011_15_27_04_+1000_34HzZs=EiWB68_6f--
