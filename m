Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2HWADJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:03:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47935 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752177Ab2HWADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:03:06 -0400
Message-ID: <1345680175.15245.15.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 40/46] KVM: PIC: call ack notifiers for irqs that are dropped
 form irr
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Date: Thu, 23 Aug 2012 01:02:55 +0100
In-Reply-To: <20120820035837.834733550@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
	 <20120820035837.834733550@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1IEaPjov3KXVaK1XJMSq"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1IEaPjov3KXVaK1XJMSq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-19 at 20:59 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Gleb Natapov <gleb@redhat.com>
>=20
> (cherry picked from commit aea218f3cbbcaac249b6b2c98930a00d6d931f1e)
>=20
> After commit 242ec97c358256 PIT interrupts are no longer delivered after
> PIC reset. It happens because PIT injects interrupt only if previous one
> was acked, but since on PIC reset it is dropped from irr it will never
> be delivered and hence acknowledged. Fix that by calling ack notifier on
> PIC reset.
[...]

Based on the commit blamed for the regression, I think this is needed
for 3.4 as well.

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-1IEaPjov3KXVaK1XJMSq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDVzL+e/yOyVhhEJAQqpKxAAqWdcjV4EFhZMkbBpw4r60W95lOZ0EghL
ytGbQSCqdGhLd+HixOzIr83JhqwrW+FgOCCszEkrvFg4ruOf/VCNpnb6xy6UHHbJ
Q30HDtbiRnW4Ux86VTQ3MsHYFT6NYvuU3oEYW73cAt316jWeCne7ePp3j3m458Kd
zzlQo30jC6Vc0UzQLjtvnUoG8mYfrLs0Txqx2o8dv52A5QoirRI5mKVZSmD15Wpf
7/IklxpLkQ6rBlYJN5QOXNWBeM/qvWbX5Ihpl3f3jsButLRNri0pYhi9jTuyqCyw
j5P7EX6aKa9K5lcYnUwnsfVZYKz6qfsXeQLZXIRLAML5c87XULAzqDLBfVYO3VvK
U2M8URnmozNROvQXchb8Y/imYwqLDCGDMGinAVXuOIdhsyH3wR28oBANyVRlAxgX
Q74iahTchttCzktN8bktzr8NWETmXPXmbBHCdZAx8Ls3JA77+HZPFaO9LsbQXIL0
EACFDWNidAbPxF451WrmEZUghMEZmMkBc9AFJHqv2tYmLT5wFrnOXRiCBwYebqaQ
i4tgjswTMH5HZO7We2NzmvEv+hmyJoCw8pgCwIRi4w9hS/QV2Ux6KFy7vS/9ytcq
tQ/25EjgGgolRpCmvrIYn+jjMGJPbvN2Aj2c4UlQDCaZbGWnu3CqY1xVfSZQeMD6
hwzz0uDMc4A=
=8+7D
-----END PGP SIGNATURE-----

--=-1IEaPjov3KXVaK1XJMSq--
