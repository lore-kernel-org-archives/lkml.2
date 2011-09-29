Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1I2J3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:29:52 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:46391 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab1I2J3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:29:49 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LSA28I-01-2BE-02
X-M-MSG: 
Date: Thu, 29 Sep 2011 11:26:43 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: Joerg Roedel <joro@8bytes.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] PCI: Add support for PASID capability
Message-ID: <20110929092643.GN2138@amd.com>
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com>
 <1316706551-16138-5-git-send-email-joerg.roedel@amd.com>
 <CAErSpo7Vb7avbsP3eG=3huCewW4QBL7oMoXr2TjMCaWEvFgB0Q@mail.gmail.com>
 <20110926221539.GG15002@8bytes.org>
 <15060.1317237495@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <15060.1317237495@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 03:18:15PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 27 Sep 2011 00:15:39 +0200, Joerg Roedel said:
> 
> > PASID stands for Process Address Space ID, it basically allows a PCI
> > device to access multiple IO address spaces at the same time using an
> > IOMMU. Users should enable it when they want to compile an IOMMU driver
> > into the kernel that supports PASIDs for the translated devices.
> > I'll add all that information to the Kconfig help. Thanks a lot for your
> > feedback :)
> 
> Is this a case where the PCI device drivers in question should be doing a
> 'select' or 'depends on' if they support talking to an IOMMU using PASID?

Exactly. In fact, I plan to put the functionality which handles these
capabilities and the fault-handling in a seperate module where all
device drivers can use it in an easy way.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

