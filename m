Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab1HJNcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:32:12 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59742 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1HJNcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:32:10 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LPPS9B-02-AZP-02
X-M-MSG: 
Date: Wed, 10 Aug 2011 15:31:59 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry (v2)
Message-ID: <20110810133158.GB7598@amd.com>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110808191354.GA22117@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110808191354.GA22117@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 03:13:54PM -0400, Neil Horman wrote:
> dma-debug: hash_bucket_find needs to allow for offsets within an entry (v2)
> 
> Summary:
> Users of the pci_dma_sync_single_* api allow users to sync address ranges within
> the range of a mapped entry (i.e. you can dma map address X to dma_addr_t A and
> then pci_dma_sync_single on dma_addr_t A+1.  The dma-debug library however
> assume dma syncs will always occur using the base address of a mapped region,
> and uses that assumption to find entries in its hash table.  Since thats often
> (but not always the case), the dma debug library can give us false errors about
> missing entries, which are reported as syncing of memory not allocated by the
> driver.  This was noted in the cxgb3 driver as this error:

Hi Neil,

thanks for your patch. Im out-of-office this week and traveling next
week. So it may take a couple of days until I can take an in-depth look
at it. But I get to it as soon as I can :-)

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

