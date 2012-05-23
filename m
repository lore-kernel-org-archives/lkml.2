Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab2EWSw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:52:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39134 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2EWSw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:52:57 -0400
Date: Wed, 23 May 2012 19:52:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Russ.Dill@ti.com, mporter@ti.com
Subject: Re: [PATCH] [ARM] Unconditional call to smp_cross_call on UP
	crashes
Message-ID: <20120523185248.GA6908@n2100.arm.linux.org.uk>
References: <1337879399-9998-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337879399-9998-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 05:09:59PM +0000, Pantelis Antoniou wrote:
> omap2plus_defconfig builds with SMP & SMP_ON_UP set.
> On beagle (which is UP) is_smp() returns false and we don't call
> smp_init_cpus which in turn does not initialize smp_cross_call which
> remains NULL.
> 
> When issuing a reboot we OOPS with a NULL dereference on stop smp_call.
> 
> Fixed by checking is_smp in smp_send_stop()

1. No sign-off, so this patch _can't_ be committed.

2. Poor description.  You say it oopses, but you don't include the oops.
So, when I read this I've no idea exactly why this is failing.  And it
_shouldn't_ fail, so I want to know what you are seeing.
