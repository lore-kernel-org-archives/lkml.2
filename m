Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1JJQEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:04:07 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:57891 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab1JJQEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:04:05 -0400
Date: Mon, 10 Oct 2011 19:03:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20111010160354.GP6685@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111010100507.GG6685@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1110101117360.18069-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wg9FEZT+WCTrEXgJ"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110101117360.18069-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wg9FEZT+WCTrEXgJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2011 at 11:19:43AM -0400, Alan Stern wrote:
> On Mon, 10 Oct 2011, Felipe Balbi wrote:
>=20
> > > > do we have sibling structures today? I dont think so.
> > >=20
> > > no we don't.
> >=20
> > Ok, here's a first shot at it:
>=20
> In fact we do already have sibling lists.  They are maintained as part=20
> of the device_private structure.  What we are missing is a=20
> device_for_each_sibling() routine.  It could be added pretty easily; it=
=20
> would be similar to device_for_each_child().

care to point out where is ?

68 struct device_private {
69         struct klist klist_children;
70         struct klist_node knode_parent;
71         struct klist_node knode_driver;
72         struct klist_node knode_bus;
73         void *driver_data;
74         struct device *device;
75 };

--=20
balbi

--wg9FEZT+WCTrEXgJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOkxdqAAoJEIaOsuA1yqRE2WAP/iaXOtBIeI8ftktO+t4FA9x3
4yNrIuUQU4bwGPb22nR+to6cdpxTc0GbawBMnMuo7cbMzNoIOBiCOL0ag4fMtvqe
WrvlzMDauF9W98Xva8OF0bwrqWRRK2VaA22Hjd7Mykp6mEBKB6BX1KyNslesipGV
N7jR2AS5yGmopaRbFyzvO9bOqV5KjNvTr3/a0eWMIpIi6JP3iin6ok87uOZTn3Pd
+xXkiaiq6tnJUnB8xeFI9ACkQS6cSt138GI7Nx+UDw2vAs3hIcY8f9XNtZ/EcIWi
pWFLZvi9Ptgymq5/2+dDyINBE2nHMuSCE4UqrmbN4g5oOQywZiyKi0BuHOyCrb8v
mps3WaQyTkvADwU0gkQJpZeGaH1Ig+lqDLXuNlsu5OH4DHp2AURpwwD9X/Lnbbey
zll8JexQtISGLp1uTXq/Ip6KrcofkVN5izM1qp8yJsoLBMZ9LkI4caIOSmh+lTuc
BAuWCgYmPuIswAd5/Nye89Zs4JHTBsto68SrP60BQaa4RdbUVMwpb5D1hEXg8+x7
KRwmOuadLGfdQ6RTWCVbi8pHkvvIGhw9C7rlQ2NzKwS9fofRVRElH8SLkcJHQ9mv
wE0VNHDp8qHrZM0FQOoPSXWHQdLkTDa1NuuTNMPf+3QLPlXq3AK/clgxoR4P68lN
5YsCLjHvxh9Yywp77FS5
=C+rW
-----END PGP SIGNATURE-----

--wg9FEZT+WCTrEXgJ--
