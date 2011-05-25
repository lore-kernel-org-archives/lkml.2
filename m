Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab1EYAo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:44:59 -0400
Received: from relais.videotron.ca ([24.201.245.36]:19168 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab1EYAo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:44:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 24 May 2011 20:44:57 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical Address
 Extensions
In-reply-to: <8yapqn7fyab.fsf@huya.qualcomm.com>
Message-id: <alpine.LFD.2.00.1105242042340.3207@xanadu.home>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
 <8yapqn7fyab.fsf@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, David Brown wrote:

> On Tue, May 24 2011, Catalin Marinas wrote:
> 
> > This set of patches adds support for the Large Physical Extensions on
> > the ARM architecture (available with the Cortex-A15 processor). LPAE
> > comes with a 3-level page table format (compared to 2-level for the
> > classic one), allowing up to 40-bit physical address space.
> 
> Do you expect non LPAE targets to be able to boot with these changes
> applied (and LPAE enabled)?  I am able to build this tree for the
> MSM8660 (with a minor patch below), but it fails to boot with LPAE
> enabled.  It seems to work fine with LPAE not enabled.

I wouldn't expect a LPAE kernel to boot on non LPAE capable hardware.

And I don't think we'll ever try to support both LPAE and non-LPAE modes 
in the same kernel binary either since this has implications all over 
the place in core kernel mm code.


Nicolas
