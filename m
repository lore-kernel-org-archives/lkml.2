Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab2FFP4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:56:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:63282 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab2FFP4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:56:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="148933295"
Message-ID: <1338998402.6875.74.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 5/7] affs: stop using lock_super
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Wed, 06 Jun 2012 19:00:02 +0300
In-Reply-To: <20120606100758.GB6304@quack.suse.cz>
References: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
	 <1338895695-10362-6-git-send-email-dedekind1@gmail.com>
	 <20120606100758.GB6304@quack.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-54lsoMl4rgSOJfHx1UIj"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-54lsoMl4rgSOJfHx1UIj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-06 at 12:07 +0200, Jan Kara wrote:
> > The VFS's 'lock_super()' and 'unlock_super()' calls are deprecated
> and unwanted
> > and just wait for a brave knight who'd kill them. This patch makes
> AFFS stop
> > using them and introduces own AFFS superblock mutex which we use for
> > serializeing the root block changes.
>   Hum, why not just use the buffer lock for this?=20

Indeed. Addressed in v2, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-54lsoMl4rgSOJfHx1UIj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPz36CAAoJECmIfjd9wqK0wzQP/1JUcxqZLn6rHTT8MS1+TZYb
pYhMAmXsoccn3kECa4FVI/OC2ljWxFGGH6ba5WmarPXdjcyZgmTXcKC5Sa2ZR2uZ
PvBZik5Cz7UT2iysXYFdgBCPeIIWRTDRMrZXcjzW7yHY2sX/6iDlJ2Jd45SxatF9
AmmlNUY4JFpp157EwrBviSDz8tiwibpYGU0kuBp0eL0b5ZMdPHDrJBVKP+nPg+LO
hmJLFe7C28DSmzyH4lHEuMweADakLCaYIQN7y2uZdc5vxN1GowHZAY3xZU17x7Kg
rNP9WnofmOq3QtPmTauFAb1NoQi0nt0/JKFyK9t3QQUnsOKs0LVwXuECZpex9z1f
nGsTcX3neFHesJS7AsWYBiyWTpkhqqVd4qV1hZtpBoZDY9wT/tETiTufGjSw5M5p
FprfGD1+AZQRtua0kmGirpqGMC3PfooXppDgOVyR/IrOdvhAatZyVXxKiGH4LTdN
3eCh6kOCk8uax2T38ayLVP+ybBLeDw3mnNuCYCZsi6RpNSSF9jc/Vx6PPIaHNfec
YrzC/l3+EVdwulrLbY5U28T/+fQ/IaEcqpAdnw1bzGkuI+2+Y+FT2BscLC2Zx6F/
8eVJXrS4A3TRvddPEmphVTb27ovr/YdIcqUEM98sZdcdQGOVSO1woOuj78xYIWY3
yZsO72pgP47FVaX/xG2g
=VXne
-----END PGP SIGNATURE-----

--=-54lsoMl4rgSOJfHx1UIj--

