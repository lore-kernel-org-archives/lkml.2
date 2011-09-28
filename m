Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1I1TS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:18:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52506 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1I1TSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:18:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Joerg Roedel <joro@8bytes.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] PCI: Add support for PASID capability
In-Reply-To: Your message of "Tue, 27 Sep 2011 00:15:39 +0200."
             <20110926221539.GG15002@8bytes.org>
From: Valdis.Kletnieks@vt.edu
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com> <1316706551-16138-5-git-send-email-joerg.roedel@amd.com> <CAErSpo7Vb7avbsP3eG=3huCewW4QBL7oMoXr2TjMCaWEvFgB0Q@mail.gmail.com>
            <20110926221539.GG15002@8bytes.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317237495_2944P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Sep 2011 15:18:15 -0400
Message-ID: <15060.1317237495@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E8372F8.00DB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317237495_2944P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Sep 2011 00:15:39 +0200, Joerg Roedel said:

> PASID stands for Process Address Space ID, it basically allows a PCI
> device to access multiple IO address spaces at the same time using an
> IOMMU. Users should enable it when they want to compile an IOMMU driver
> into the kernel that supports PASIDs for the translated devices.
> I'll add all that information to the Kconfig help. Thanks a lot for your
> feedback :)

Is this a case where the PCI device drivers in question should be doing a
'select' or 'depends on' if they support talking to an IOMMU using PASID?

--==_Exmh_1317237495_2944P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOg3L3cC3lWbTT17ARAgPiAKCRBQJ4KjD/sNFXHqFDBQKeLfG7VwCdHV6G
rQR9ODIW9z9rI/AQdMlf9U4=
=Sghw
-----END PGP SIGNATURE-----

--==_Exmh_1317237495_2944P--

