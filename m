Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0FJKwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:52:00 -0400
Received: from smtp208.alice.it ([82.57.200.104]:44504 "EHLO
	smtp208-alice.cp.alice.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758100Ab0FJKv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:51:58 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jun 2010 06:51:58 EDT
Date: Thu, 10 Jun 2010 12:45:11 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>,
       Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] HID: Add Support for Setting and Getting Feature
 Reports from hidraw
Message-Id: <20100610124511.973a2ca5.ospite@studenti.unina.it>
In-Reply-To: <1276098868-3262-1-git-send-email-alan@signal11.us>
References: <1275969108-14948-1-git-send-email-alan@signal11.us>
	<1276098868-3262-1-git-send-email-alan@signal11.us>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Jun_2010_12_45_11_+0200_=L0YqTYKWoKfYaWU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Jun_2010_12_45_11_+0200_=L0YqTYKWoKfYaWU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed,  9 Jun 2010 11:54:28 -0400
Alan Ott <alan@signal11.us> wrote:

> Per the HID Specification, Feature reports must be sent and received on
> the Configuration endpoint (EP 0) through the Set_Report/Get_Report
> interfaces.  This patch adds two ioctls to hidraw to set and get feature
> reports to and from the device.  Modifications were made to hidraw and
> usbhid.
>=20
> New hidraw ioctls:
>   HIDIOCSFEATURE - Perform a Set_Report transfer of a Feature report.
>   HIDIOCGFEATURE - Perform a Get_Report transfer of a Feature report.
>=20
> Signed-off-by: Alan Ott <alan@signal11.us>

Tested-by: Antonio Ospite <ospite@studenti.unina.it>

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Thu__10_Jun_2010_12_45_11_+0200_=L0YqTYKWoKfYaWU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwQwjcACgkQ5xr2akVTsAGi5QCfddQ3+Tw0qKSEPpahyuFJul2y
KloAn04s+M7U21CxsUH6G4FJmr/5FKvg
=f32D
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Jun_2010_12_45_11_+0200_=L0YqTYKWoKfYaWU--
