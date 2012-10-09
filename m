Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2JIRhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:37:20 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:53787 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab2JIRhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:37:14 -0400
Date: Tue, 9 Oct 2012 11:37:06 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121009173706.GE4124@obsidianresearch.com>
References: <20120930232116.GC30637@obsidianresearch.com>
 <20121001153952.GB2100@linaro.org>
 <20121001160639.GA31620@obsidianresearch.com>
 <20121005084500.GI4625@n2100.arm.linux.org.uk>
 <20121008102413.GC2302@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008102413.GC2302@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:24:13AM +0100, Dave Martin wrote:

> Partly this came from some side speculation about whether we could do
> things like privileged read-only permissions on newer CPUs, for preventing
> unintended or undesired writes to the kernel's code or read-only data.

Some other arches page protect the kernel, but that tends to be at
odds with the desire to use huge pages for the kernel mapping, and
independent of the load headers..

Jason
