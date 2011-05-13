Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1EMG7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:59:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57456 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab1EMG7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:59:19 -0400
Date: Fri, 13 May 2011 08:59:03 +0200
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ulrich Weigand <ulrich.weigand@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, patches@linaro.org
Subject: Re: [PATCH v4 1/2] ARM: ELF: Define new core note type for VFP
 registers
Message-ID: <20110513065902.GA2867@localhost>
References: <1302688597-2969-1-git-send-email-dave.martin@linaro.org>
 <1302688597-2969-2-git-send-email-dave.martin@linaro.org>
 <20110428184925.GM17290@n2100.arm.linux.org.uk>
 <20110503093659.GA2503@arm.com>
 <20110512091400.GC1356@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512091400.GC1356@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:14:00AM +0100, Russell King - ARM Linux wrote:
> On Tue, May 03, 2011 at 10:36:59AM +0100, Dave Martin wrote:
> > On Thu, Apr 28, 2011 at 07:49:25PM +0100, Russell King - ARM Linux wrote:
> > > On Wed, Apr 13, 2011 at 10:56:36AM +0100, Dave Martin wrote:
> > > > The VFP registers are not currently included in coredumps,
> > > > and there's no existing note type where they can sensibly be
> > > > included, so this patch defines a dedicated note type for them.
> > > 
> > > This probably wants to be copied to LKML (added).
> > 
> > Good point-- thanks.
> 
> What news on this?

None whatsoever.  Do you think I need to push harder for feedback?

---Dave
