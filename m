Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1BOPYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:24:17 -0500
Received: from service87.mimecast.com ([94.185.240.25]:32965 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751201Ab1BOPYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:24:15 -0500
Subject: Re: [PATCH v4 16/19] ARM: LPAE: Use generic dma_addr_t type
 definition
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
In-Reply-To: <20110215142730.GM4152@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-17-git-send-email-catalin.marinas@arm.com>
	 <20110212103413.GD15616@n2100.arm.linux.org.uk>
	 <1297688490.31111.38.camel@e102109-lin.cambridge.arm.com>
	 <20110215142730.GM4152@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Tue, 15 Feb 2011 15:24:06 +0000
Message-ID: <1297783446.14691.167.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 15 Feb 2011 15:24:09.0278 (UTC) FILETIME=[6423DDE0:01CBCD24]
X-MC-Unique: 111021515241209601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 14:27 +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 14, 2011 at 01:01:30PM +0000, Catalin Marinas wrote:
> > Maybe we could make the dma_addr_t size configurable (and disabled by
> > default) since I expect there'll be platforms capable of >32-bit DMA.
> 
> It would be far better to fix the dma_addr_t abuses.

That's not a simple task, I have no idea how many drivers get used on
ARM systems. We can defer this until people start using Cortex-A15 in
real hardware and only fix the drivers they need.

BTW, can sparse help here (I haven't used it much)?

-- 
Catalin


