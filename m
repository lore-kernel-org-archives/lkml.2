Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab1DHSdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:33:09 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:35093 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab1DHSdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:33:07 -0400
From: Rolf Eike Beer <eike@sf-mail.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/5] PCI: Move ATS declarations in seperate header file
Date: Fri, 08 Apr 2011 20:33:04 +0200
Message-Id: <4435339.aQcLV4iHRH@donald.sf-tec.de>
User-Agent: KMail/4.6 beta4 (Linux/2.6.37-12-desktop; KDE/4.6.1; i686; ; )
In-Reply-To: <1302250630-8183-2-git-send-email-joerg.roedel@amd.com>
References: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com> <1302250630-8183-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2491071.nCS1T0UNAk"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2491071.nCS1T0UNAk
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Am Freitag, 8. April 2011, 10:17:06 schrieb Joerg Roedel:
> This patch moves the relevant declarations from the local
> header file in drivers/pci to a more accessible locations so
> that it can be used by the AMD IOMMU driver too.
> The file is named pci-ats-pri.h because support for the PCI
                    ^^^^^^^^^^^^^

>  include/linux/pci-ats.h   |   52
                 ^^^^^^^^^

Ehm, no, it is not ;)

Eike
--nextPart2491071.nCS1T0UNAk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk2fVOYACgkQXKSJPmm5/E4b0gCfZuP8pTt6JmMntFOAOW8N5MpZ
PbEAoJP/OKbFaMsFUIDyJZLoE+O091+0
=feAW
-----END PGP SIGNATURE-----

--nextPart2491071.nCS1T0UNAk--

