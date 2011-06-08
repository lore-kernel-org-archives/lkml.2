Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1FHOdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:33:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab1FHOdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:33:07 -0400
Date: Wed, 8 Jun 2011 16:32:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 0/4] drivers/iommu/ relocations
Message-ID: <20110608143245.GI30752@elte.hu>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
 <20110608093546.GG4407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608093546.GG4407@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roedel, Joerg <Joerg.Roedel@amd.com> wrote:

> (Cc'ing Ingo)
> 
> On Wed, Jun 08, 2011 at 04:34:18AM -0400, Ohad Ben-Cohen wrote:
> > Create a dedicated iommu drivers folder, put the base iommu code there,
> > and move the existing IOMMU API users as well (msm-iommu, amd_iommu and
> > intel-iommu).
> > 
> > Putting all iommu drivers together will ease finding similarities
> > between different platforms, with the intention of solving problems once,
> > in a generic framework, which everyone can use.
> > 
> > OMAP's iommu will be moved too as soon as it's migrated.
> 
> Great, thanks. I'll apply the patches as soon as the relevant ACKs come
> in. Looking at the MAINTAINERS file David Brown needs to ACK the MSM
> patch and David Woodhouse the VT-d patch.
> 
> David B., David W., is this direction ok for both of you?
> 
> A more important question is how we handle the IOMMU tree. Currently the
> situation is as follows:
> 
> 	* The AMD IOMMU changes go upstream through Ingo
> 	* David Woohouse has his own tree which he sents directly to
> 	  Linus
> 	* Not sure about the ARM IOMMU code
> 	* And to comlicate things further there is the upcoming ARM
> 	  integration tree which may contain code that depends on IOMMU
> 	  changes
> 
> My suggestion is that the ARM tree pulls in the necessary changes from
> the IOMMU tree and the IOMMU code goes upstream through Ingo or directly
> to Linus (with some time in linux-next, of course). Thoughts?

I can certainly pull from you trees you pull from elsewhere.

David could help keep things tidier by sending the Intel IOMMU bits 
to me as well.

In any case the tip:core/iommu tree is in linux-next so whatever you 
send me shows up there on the next day or so.

Thanks,

	Ingo
