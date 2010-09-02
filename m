Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0IBF7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:59:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0IBF7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jaVcTEGbRzL90HDm/ghMfGkS2jXE3Lt7vo05TWgLGxnP41Xwic+uwtfiA6RH+LnCRC
         /tcT3tGxJHypMEMN01lhh+/a4Exr0bDOeG9tp5QiJl5pfL7XeLZHaUEXBERozTMXzWTU
         A1KiNrtoxYxMAc//qYzm7oxBAQjzqtud9IKBQ=
Date: Thu, 2 Sep 2010 07:59:07 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, khc@pm.waw.pl,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        eric.y.miao@gmail.com
Subject: Re: [PATCH] arm: fix pci_set_consistent_dma_mask for dmabounce
 devices
Message-ID: <20100902055907.GA3287@riccoc20.at.omicron.at>
References: <20100819174426O.fujita.tomonori@lab.ntt.co.jp>
 <m3sk1yzkjw.fsf@intrepid.localdomain>
 <20100901085738.GJ8142@n2100.arm.linux.org.uk>
 <20100902114937X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902114937X.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 11:50:33AM +0900, FUJITA Tomonori wrote:
> btw, I can't compile ARCH_IXP4XX without the following patch:
> 
> http://www.spinics.net/lists/arm-kernel/msg95933.html

I have the same problem. Compilation of IXP4xx was broken by

    commit 4fa5518c65df7a2c4b6c58061ac53d0b01228042
    Author: Eric Miao <eric.y.miao@gmail.com>
    Date:   Sat Jun 5 15:16:17 2010 +0800

    [ARM] pxa: remove now unnecessary dma_needs_bounce()

What is the correct way to do fix this? Is the above patch the
solution, or is dma_needs_bounce() perhaps also unnecessary for ixp?

Thanks,
Richard
