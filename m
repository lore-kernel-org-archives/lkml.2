Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2BCJK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:10:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37335 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2BCJKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:10:49 -0500
Date: Fri, 3 Feb 2012 09:10:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [dmaengine] [Q] jiffies value does not increase in
	dma_sync_wait()
Message-ID: <20120203091038.GI889@n2100.arm.linux.org.uk>
References: <CACKLOr26BuTh8Qr8pFHoTJoyCW9ty4-Kg-YRisXmN3=spzY6_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr26BuTh8Qr8pFHoTJoyCW9ty4-Kg-YRisXmN3=spzY6_Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 09:37:48AM +0100, javier Martin wrote:
> I've introduced a couple of printk() to check why this timeout is not
> triggered and I've found that the value of jiffies does not increase
> between loop iterations (i. e. it's like time didn't advance).
> 
> Does anyobody know what reasons could make jiffies not being updated?

Are interrupts disabled?
