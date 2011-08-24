Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab1HXBGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:06:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53482 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1HXBGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:06:19 -0400
Date: Wed, 24 Aug 2011 11:06:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>, Greg KH <gregkh@suse.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless & staging trees related)
Message-Id: <20110824110612.8764b7615a160c2939fd01cf@canb.auug.org.au>
In-Reply-To: <20110823213013.GC3679@kroah.com>
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
	<4E438D56.5020801@qca.qualcomm.com>
	<20110811141604.GA14763@suse.de>
	<4E43FA61.1010301@qca.qualcomm.com>
	<20110812121216.28e6979b44bacb651849640b@canb.auug.org.au>
	<20110812135101.GA2286@tuxdriver.com>
	<4E453502.4000401@qca.qualcomm.com>
	<20110823213013.GC3679@kroah.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Aug_2011_11_06_12_+1000_AffRCo2dPx7ILXj3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Aug_2011_11_06_12_+1000_AffRCo2dPx7ILXj3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 23 Aug 2011 14:30:13 -0700 Greg KH <greg@kroah.com> wrote:
>
> Note, I also applied this to the staging-next tree to keep people from
> sending me cleanup patches against the driver.  git will resolve the
> fact that it was deleted in both branches just fine when we merge with
> Linus for 3.2.

Clearly, I should read ahead in my email before replying :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Aug_2011_11_06_12_+1000_AffRCo2dPx7ILXj3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVE6EAAoJEDMEi1NhKgbsPXoH/37lHOWnoakUPOef7/EIPPAN
9M8OlFM8gnVwBesGHgrSlixcgs3Qeg58VMtJz0UubrhXNN9STXbM59x3BDyuV5W5
VryuGocCaMU3jtQEnvKQGHvPeAkwSUfj3ff7Wm6o51X3O8g3DPQ7AFn3nxPLAjzz
9kiiya00IIkUrv3OCTJ3RR+Db6BCyjqiIt5f7s8rGSp+acc8ETVgsplu7FCDrPOn
12eztgoZTKKPJBJKqDvu973c3UMtFXDHe8QR3etUy/EaO920FEAjnY03AdahwxfH
lxfi8Q3WRf/PYn/7RdWYQ6Cz0Gdy7dlYjKIBDvNXm1ZBA8NeGTDdl/HNARnuk4o=
=xEyE
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Aug_2011_11_06_12_+1000_AffRCo2dPx7ILXj3--
