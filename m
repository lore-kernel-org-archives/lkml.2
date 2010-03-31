Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab0CaBz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:55:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55339 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0CaBzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:55:53 -0400
Date: Wed, 31 Mar 2010 03:55:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: fix lockdep warning
Message-ID: <20100331015544.GA3520@pengutronix.de>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com> <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com> <m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org> <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org> <4BA47692.7040401@kernel.org> <4bb21338.0d0db80a.1685.ffffb9e1@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <4bb21338.0d0db80a.1685.ffffb9e1@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Moreover, there are still failures in the ACPI thermal driver (at very le=
ast)
> on master (9623e5a23724d09283c238960946ec6f65733afe).

https://patchwork.kernel.org/patch/87436/
(or https://bugzilla.kernel.org/show_bug.cgi?id=3D15548)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuyq6AACgkQD27XaX1/VRtgpACgqDUPeQ/SnYZHmiIgXYaLM69h
5gUAnA2yXfIFLTll9DZqLbLwEXqT4CJF
=jL77
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
