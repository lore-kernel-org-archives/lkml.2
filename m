Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1BUPBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:01:19 -0500
Received: from service87.mimecast.com ([94.185.240.25]:56850 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751113Ab1BUPBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:01:18 -0500
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
 unsigned long for physical addresses
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110221145818.GQ14495@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
	 <20110219182631.GS29493@n2100.arm.linux.org.uk>
	 <1298299008.19814.20.camel@e102144-lin.cambridge.arm.com>
	 <20110221145818.GQ14495@n2100.arm.linux.org.uk>
Date: Mon, 21 Feb 2011 15:01:04 +0000
Message-ID: <1298300464.20460.1.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 21 Feb 2011 15:01:08.0186 (UTC) FILETIME=[2B6C73A0:01CBD1D8]
X-MC-Unique: 111022115011102901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 14:58 +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 21, 2011 at 02:36:47PM +0000, Will Deacon wrote:
> > Would you like me to submit an additional patch or are you happy merging
> > this diff in with my ack?
> 
> The latter - I've already merged it and if you give an ack I'll add that.
> 
Acked-by: Will Deacon <will.deacon@arm.com>

Thanks,

Will


