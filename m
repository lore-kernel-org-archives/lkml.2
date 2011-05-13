Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1EMH34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:29:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37061 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab1EMH3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:29:55 -0400
Date: Fri, 13 May 2011 09:29:50 +0200 (CEST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Dave Martin <dave.martin@linaro.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulrich Weigand <ulrich.weigand@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, patches@linaro.org
Subject: Re: [PATCH v4 1/2] ARM: ELF: Define new core note type for VFP
 registers
In-Reply-To: <20110513065902.GA2867@localhost>
Message-ID: <alpine.LFD.2.00.1105130926180.2762@xanadu.home>
References: <1302688597-2969-1-git-send-email-dave.martin@linaro.org> <1302688597-2969-2-git-send-email-dave.martin@linaro.org> <20110428184925.GM17290@n2100.arm.linux.org.uk> <20110503093659.GA2503@arm.com> <20110512091400.GC1356@n2100.arm.linux.org.uk>
 <20110513065902.GA2867@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, Dave Martin wrote:

> On Thu, May 12, 2011 at 10:14:00AM +0100, Russell King - ARM Linux wrote:
> > On Tue, May 03, 2011 at 10:36:59AM +0100, Dave Martin wrote:
> > > On Thu, Apr 28, 2011 at 07:49:25PM +0100, Russell King - ARM Linux wrote:
> > > > On Wed, Apr 13, 2011 at 10:56:36AM +0100, Dave Martin wrote:
> > > > > The VFP registers are not currently included in coredumps,
> > > > > and there's no existing note type where they can sensibly be
> > > > > included, so this patch defines a dedicated note type for them.
> > > > 
> > > > This probably wants to be copied to LKML (added).
> > > 
> > > Good point-- thanks.
> > 
> > What news on this?
> 
> None whatsoever.  Do you think I need to push harder for feedback?

I think that the patch should just be merged.  If someone had a problem 
with this, we would have heard about it by now.


Nicolas
