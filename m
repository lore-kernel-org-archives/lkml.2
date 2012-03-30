Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab2C3KqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:46:13 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:14920 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756201Ab2C3KqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:46:07 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
To: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, daniel@ffwll.ch
In-Reply-To: <4F758400.3080907@suse.cz>
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz>
Date: Fri, 30 Mar 2012 11:45:43 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333104359_155028@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> I don't know what to dump more, because iir is obviously zero too. What
> other sources of interrupts are on the (G33) chip?

IIR is the master interrupt, with chained secondary interrupt statuses.
If IIR is 0, the interrupt wasn't raised by the GPU.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
