Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2HFKuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:50:16 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:2886
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068Ab2HFKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:50:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI179dNzz1202hzz15d4Iz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M8BY3I-01-0C3-02
X-M-MSG: 
Date: Mon, 6 Aug 2012 12:50:10 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dsahern@gmail.com>
Subject: Re: [PATCH 0/2] Fix ACS path checking
Message-ID: <20120806105010.GK1996@amd.com>
References: <20120804180155.6144.83332.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120804180155.6144.83332.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 12:08:46PM -0600, Alex Williamson wrote:
> Joerg, I notice that ACS isn't getting enabled on my AMD system on
> 3.6-rc1.  I'll investigate more, but mention it in case you get to
> it first.

Hmm, tried it here, At least pci_request_acs() still gets called. How do
you detect if ACS is really enabled?

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

