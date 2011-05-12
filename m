Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1ELJOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:14:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43785 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab1ELJON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:14:13 -0400
Date: Thu, 12 May 2011 10:14:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ulrich Weigand <ulrich.weigand@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, patches@linaro.org
Subject: Re: [PATCH v4 1/2] ARM: ELF: Define new core note type for VFP
	registers
Message-ID: <20110512091400.GC1356@n2100.arm.linux.org.uk>
References: <1302688597-2969-1-git-send-email-dave.martin@linaro.org> <1302688597-2969-2-git-send-email-dave.martin@linaro.org> <20110428184925.GM17290@n2100.arm.linux.org.uk> <20110503093659.GA2503@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503093659.GA2503@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:36:59AM +0100, Dave Martin wrote:
> On Thu, Apr 28, 2011 at 07:49:25PM +0100, Russell King - ARM Linux wrote:
> > On Wed, Apr 13, 2011 at 10:56:36AM +0100, Dave Martin wrote:
> > > The VFP registers are not currently included in coredumps,
> > > and there's no existing note type where they can sensibly be
> > > included, so this patch defines a dedicated note type for them.
> > 
> > This probably wants to be copied to LKML (added).
> 
> Good point-- thanks.

What news on this?
