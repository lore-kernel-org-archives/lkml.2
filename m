Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1FHWXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:23:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8152 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1FHWXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:23:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6371"; a="96308488"
From: David Brown <davidb@codeaurora.org>
To: "Roedel\, Joerg" <Joerg.Roedel@amd.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        "iommu\@lists.linux-foundation.org" 
	<iommu@lists.linux-foundation.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] drivers/iommu/ relocations
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
	<20110608093546.GG4407@amd.com>
Date: Wed, 08 Jun 2011 15:23:10 -0700
In-Reply-To: <20110608093546.GG4407@amd.com> (Joerg Roedel's message of "Wed,
	8 Jun 2011 11:35:46 +0200")
Message-ID: <8yar574klo1.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08 2011, Roedel, Joerg wrote:

> Great, thanks. I'll apply the patches as soon as the relevant ACKs come
> in. Looking at the MAINTAINERS file David Brown needs to ACK the MSM
> patch and David Woodhouse the VT-d patch.
>
> David B., David W., is this direction ok for both of you?

I think it is a good direction to move in.  I'll reply to the patch
directly to comment on it.

> My suggestion is that the ARM tree pulls in the necessary changes from
> the IOMMU tree and the IOMMU code goes upstream through Ingo or directly
> to Linus (with some time in linux-next, of course). Thoughts?

This seems the cleanest to me.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
