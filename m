Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2EaNv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:51:29 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab2EaNv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:51:27 -0400
Message-ID: <4FC7729C.3000307@nod.at>
Date: Thu, 31 May 2012 15:31:08 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: linux-mtd@lists.infradead.org, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
References: <1337771191-95358-1-git-send-email-richard@nod.at> <1337771191-95358-2-git-send-email-richard@nod.at> <4FC74A04.30100@intel.com>
In-Reply-To: <4FC74A04.30100@intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8D7BA475F269EFAC6255320E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8D7BA475F269EFAC6255320E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 31.05.2012 12:37, schrieb Adrian Hunter:
> How do you know that this is the current fastmap and not a remnant of a=
n old
> fastmap?

In the current fastmap we delete always the old one upon attaching.
But I think it would to better to scan all UBI_FM_MAX_START PEBs
and pick the super block with the highest sequence number.

Thanks,
//richard


--------------enig8D7BA475F269EFAC6255320E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPx3KhAAoJEN9758yqZn9emCAIAKLqtvG3Yu272VSpCrsyYh70
VaaCSG9ZOHGTyvZ8x9o3EHLNbRvIDUmX9lhSNbIUNjtcCXKRuCMU0Rbpre5r+Z5p
rxyM9IIHpgAmcMuK7Jb4o6kFxm/H5YR5dqHIeCVR0dy+nY0u5R1gktAHGvlNLwT+
dRj2MuSpCsPLqPT2K8iCA+jSlaXz4sKRlsIl4smKcClzPQYFOlrYlHQmfuVAMnUo
XF9jIULFGBm6rJA5ZziXQ4y8gi5FRrpJIn+HosSBC0VUn001W6JkdBZvdHemWVqZ
CWeZQ+cnZh/NraIrgZZiJx3GQ8iNkiyWaVb864nsaH8KsWEOV7tG2SwYAaEDBUE=
=ci0A
-----END PGP SIGNATURE-----

--------------enig8D7BA475F269EFAC6255320E--
