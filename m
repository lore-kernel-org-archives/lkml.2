Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2JJJSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:18:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37053 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2JJJSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:18:43 -0400
Date: Wed, 10 Oct 2012 10:18:29 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121010091829.GA2131@linaro.org>
References: <20120930232116.GC30637@obsidianresearch.com>
 <20121001153952.GB2100@linaro.org>
 <20121001160639.GA31620@obsidianresearch.com>
 <20121005084500.GI4625@n2100.arm.linux.org.uk>
 <20121008102413.GC2302@linaro.org>
 <20121009173706.GE4124@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009173706.GE4124@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:37:06AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 08, 2012 at 11:24:13AM +0100, Dave Martin wrote:
> 
> > Partly this came from some side speculation about whether we could do
> > things like privileged read-only permissions on newer CPUs, for preventing
> > unintended or undesired writes to the kernel's code or read-only data.
> 
> Some other arches page protect the kernel, but that tends to be at
> odds with the desire to use huge pages for the kernel mapping, and
> independent of the load headers..

This wasn't so much about that headers themselves as about fragmentation
of the page permissions which makes it difficult to map everything using
huge pages / sections.  But as you say, there are conflicting concerns
here, and it seems not to be a priority.

Privileged write-protect is nice to have if non-disruptive, but not
essential.

Cheers
---Dave
