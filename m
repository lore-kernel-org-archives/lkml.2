Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1JMRoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:44:11 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57331 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab1JMRoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:44:09 -0400
Date: Thu, 13 Oct 2011 20:43:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sshtylyov@ru.mvista.com
Subject: Re: [PATCH v4] usb: add new usb gadget for ACM and mass storage
Message-ID: <20111013174357.GM28290@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <1318235543-24203-1-git-send-email-schwarzkopf@sensortherm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JlJsEFsx9RQyiX4C"
Content-Disposition: inline
In-Reply-To: <1318235543-24203-1-git-send-email-schwarzkopf@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JlJsEFsx9RQyiX4C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2011 at 10:32:23AM +0200, Klaus Schwarzkopf wrote:
> This driver provides two functions in one configuration:
> a mass storage, and a ACM (serial port) link.
> Heavily based on multi.c and cdc2.c
>=20
> Signed-off-by: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>

applied, thanks

--=20
balbi

--JlJsEFsx9RQyiX4C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlyNdAAoJEIaOsuA1yqRESWgQAIKstvjP1iNegvUYnLZMAJ8A
6Emg/4vcwn7d0LxuMH30FNvQ7tSCcR/zzCk+NjA1X7u+RL1V3MP5j0uR0I4QHTqa
f/ACmYKv2uNuoBYs9fpsjwUXMtk2fejbBO8hJPGmwS17xZKUIRVuwudIbyjBtgLf
akK6BteoJ+nwjWwngLqu3d4fBR7nbHP6MUz58+9a/rqsrcqndOE9TdwfY8NO9bCk
f761qg20TVFxk5V9cu1WcCn+oF0Gaqf8TSRxM/EeitxWlsT4DsMeYqMHqWtFhYEN
FjL0POEyR2pUO+P88zwPovIrcy5nL6mwaEwKSFt+mqCRsZwRFIKkWj1YCQY7TlR0
vLNzcqxcnT3unkNI3SkQuVWl1ZQztKZMZ+illoIxQ5wBt+FkMno2Nz7cnil/Ib/E
DFu+ai8ycZZ9b7JPXSRU8LF1aqV8MCv5QRteeNlS6CQjQKuWFXcCpbg+T2EIp0yD
yOJWnh5FNVUVi4aiFPH2L5cXFWiJfy2K21Tzf3J1bp0cFhRtek3UiMAKTl9OWe0a
jfa6B0cKxq5WzxarIUM+Y1dUFrgypBweGrirFgpmLo+f0utUTm1X8a3TdmZ5KZq3
AmLDTfv6wEGf0+Ha8NAiUSJGz5h+M/KYtId4GYgRxZx7fK50xnXYSwyIzipfhIYv
fnDA56IyAW5pMOztk4mW
=+Z9B
-----END PGP SIGNATURE-----

--JlJsEFsx9RQyiX4C--
