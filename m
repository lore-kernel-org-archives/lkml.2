Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2BCJZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:25:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44342 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2BCJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:25:03 -0500
Date: Fri, 3 Feb 2012 09:24:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [dmaengine] [Q] jiffies value does not increase in
	dma_sync_wait()
Message-ID: <20120203092456.GJ889@n2100.arm.linux.org.uk>
References: <CACKLOr26BuTh8Qr8pFHoTJoyCW9ty4-Kg-YRisXmN3=spzY6_Q@mail.gmail.com> <20120203091038.GI889@n2100.arm.linux.org.uk> <CACKLOr3_nsWy7z3QQejFbmgJJ78Nhv8J6fHFe=WjeAtghoCa5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr3_nsWy7z3QQejFbmgJJ78Nhv8J6fHFe=WjeAtghoCa5w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 10:22:00AM +0100, javier Martin wrote:
> Hi Russell,
> 
> On 3 February 2012 10:10, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Feb 03, 2012 at 09:37:48AM +0100, javier Martin wrote:
> >> I've introduced a couple of printk() to check why this timeout is not
> >> triggered and I've found that the value of jiffies does not increase
> >> between loop iterations (i. e. it's like time didn't advance).
> >>
> >> Does anyobody know what reasons could make jiffies not being updated?
> >
> > Are interrupts disabled?
> 
> Apparently not but, how could I check it for sure? Is
> "irqs_disabled()" suitable for that purpose?

Yes.
