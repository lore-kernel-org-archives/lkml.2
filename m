Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131Ab0HEQPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:15:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:33418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab0HEQPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:15:18 -0400
Subject: Re: [PATCH 2/3] powerpc: implement arch_setup_pdev_archdata
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20100806014455.8cab0ae9.sfr@canb.auug.org.au>
Date: Thu, 5 Aug 2010 11:14:57 -0500
Cc: gregkh@suse.de, linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <462C7602-3D2F-4B85-9F4A-15D12B30B423@kernel.crashing.org>
References: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org> <1281021347-1278-2-git-send-email-galak@kernel.crashing.org> <1281021347-1278-3-git-send-email-galak@kernel.crashing.org> <20100806014455.8cab0ae9.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 5, 2010, at 10:44 AM, Stephen Rothwell wrote:

> Hi Kumar,
> 
> On Thu,  5 Aug 2010 10:15:46 -0500 Kumar Gala <galak@kernel.crashing.org> wrote:
>> 
>> +static inline void arch_setup_pdev_archdata(struct platform_device *pdev)
>> +{
>> +	pdev->dev.dma_mask = &pdev->archdata.dma_mask;
>> +
>> +	return;
>> +}
> 
> The blank line and "return;" don't add anything.

Will fix.

- k