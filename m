Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1FGKEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:04:01 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:34541
	"EHLO CH1EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752484Ab1FGKD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:03:59 -0400
X-SpamScore: -16
X-BigFish: VPS-16(z1039oz9371M1432N98dKzz1202hzz15d4R8275bhz32i668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMEZP2-01-GGD-02
X-M-MSG: 
Date: Tue, 7 Jun 2011 11:58:29 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
Message-ID: <20110607095829.GD4407@amd.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <20110606100950.GC30762@amd.com>
 <BANLkTi=i2s-Ujiy4qn_XQv+9dMjUC9R66A@mail.gmail.com>
 <20110606153557.GE1953@amd.com>
 <BANLkTinwwVO4TmsxuTfSBf6jqYrEVV3b_A@mail.gmail.com>
 <20110606192030.GA4356@amd.com>
 <BANLkTinx21-E3DRe9D7LRB8e1aeOwv=-9A@mail.gmail.com>
 <20110607075221.GB4407@amd.com>
 <BANLkTimR3KofKA3LSKXdX8k1FGR0XUxu=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTimR3KofKA3LSKXdX8k1FGR0XUxu=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 05:22:11AM -0400, Ohad Ben-Cohen wrote:
> On Tue, Jun 7, 2011 at 10:52 AM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > Yup. Btw, is there any IOMMU hardware which supports non-natural
> > alignment? In this case we need to expose these requirements somehow.
> 
> Not sure there are. Let's start with natural alignment, and extend it
> only if someone with additional requirements shows up.

Btw, mind to split out your changes which move the iommu-api into
drivers/iommu? I can merge them meanwhile into my iommu tree and start
working on a proposal for the generic large page-size support.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

