Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab1FAKDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:03:52 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:38726 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab1FAKDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:03:49 -0400
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h8JiYXs/HrEl2yUn8V3w==
X-RZG-CLASS-ID: mo05
Message-ID: <4DE60E7E.3080300@samba.org>
Date: Wed, 01 Jun 2011 12:03:42 +0200
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet/cdc_ncm: add missing .reset_resume hook
References: <1306919630-13426-1-git-send-email-metze@samba.org> <1306919630-13426-2-git-send-email-metze@samba.org> <201106011143.46667.oneukum@suse.de>
In-Reply-To: <201106011143.46667.oneukum@suse.de>
X-Enigmail-Version: 1.1.2
OpenPGP: id=0E53083F
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9144ACF09BF9ABBADC4AFBDB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9144ACF09BF9ABBADC4AFBDB
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 01.06.2011 11:43, schrieb Oliver Neukum:
> Am Mittwoch, 1. Juni 2011, 11:13:50 schrieb Stefan Metzmacher:
>> This avoids messages like this after suspend:
>>
>>    cdc_ncm 2-1.4:1.6: no reset_resume for driver cdc_ncm?
>>    cdc_ncm 2-1.4:1.7: no reset_resume for driver cdc_ncm?
>>    cdc_ncm 2-1.4:1.6: usb0: unregister 'cdc_ncm' usb-0000:00:1d.0-1.4,=
 CDC NCM
>>
>> This is important for the Ericsson F5521gw GSM/UMTS modem.
>> Otherwise modemmanager looses the fact that the cdc_ncm and cdc_acm de=
vices
>> belong together.
>>
>> The cdc_ether module does the same.
>=20
> Yes, it does. Have you tested this with active connections and unconnec=
ted?

Yes, I've just tested suspend while having an active connection
(My original tests where without an active connection).

BTW: I'm testing this on top of linux-image-2.6.38-8-generic from ubuntu
11.04.

metze


--------------enig9144ACF09BF9ABBADC4AFBDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3mDn4ACgkQm70gjA5TCD+O2ACgrrfty515dHzeOgXg4qcYQpdV
WeYAoMaBKMmob/5Bxe22z2pHW/1wJb/9
=GeEt
-----END PGP SIGNATURE-----

--------------enig9144ACF09BF9ABBADC4AFBDB--
