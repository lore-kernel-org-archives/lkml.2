Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1FFPfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:35:43 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:34803
	"EHLO CH1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752287Ab1FFPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:35:41 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z1039oz98dKzz1202hzz15d4Rz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMDKNB-02-B4A-02
X-M-MSG: 
Date: Mon, 6 Jun 2011 17:35:57 +0200
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
Message-ID: <20110606153557.GE1953@amd.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <20110606100950.GC30762@amd.com>
 <BANLkTi=i2s-Ujiy4qn_XQv+9dMjUC9R66A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTi=i2s-Ujiy4qn_XQv+9dMjUC9R66A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:15:30AM -0400, Ohad Ben-Cohen wrote:

> This is insufficient; users need somehow to tell what page sizes are
> supported by the underlying hardware (we can't assume host page-sizes,
> and we want to use bigger pages whenever possible, to relax the TLB
> pressure).
/
What does the IOMMU-API user need this info for? On the x86 IOMMUs these
details are handled transparently by the IOMMU driver.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

