Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab1E0JmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:42:12 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:9688
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab1E0JmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:42:09 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4R8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLULM1-02-07I-02
X-M-MSG: 
Date: Fri, 27 May 2011 11:42:09 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Greg KH <greg@kroah.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Mike Travis <travis@sgi.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Mike Habeck <habeck@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] [PATCH 1/7] Intel pci: Check for identity mapping
 candidate using system dma mask
Message-ID: <20110527094209.GB27062@amd.com>
References: <20110527013221.231071058@gulag1.americas.sgi.com>
 <20110527013221.405688800@gulag1.americas.sgi.com>
 <20110527071838.GA16217@kroah.com>
 <20110527093042.GG21386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110527093042.GG21386@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 05:30:42AM -0400, Ingo Molnar wrote:
> 
> * Greg KH <greg@kroah.com> wrote:
> 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the 
> > stable kernel tree.  Please read 
> > Documentation/stable_kernel_rules.txt for how to do this properly.
> > 
> > </formletter>
> > 
> > I'll not send this out for the other 6 patches that also do not 
> > follow the proper format, as I'm sure you would get bored reading 
> > them.
> 
> None of these patches exist upstream yet so it will take some time 
> until any of this can touch -stable. You can ignore it safely for 
> now.
> 
> Mike: please add proposed stable Cc: tags in the patch only, never 
> send it out to the stable email address itself!!

Well, with the Cc: tag git-send-email will Cc it automatically if not
done by the user explicitly.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

