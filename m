Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2FTIrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:47:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58915 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2FTIrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:47:05 -0400
Date: Wed, 20 Jun 2012 09:45:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Gupta, Ramesh" <grgupta@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH v2 2/4] ARM: add flush_mem api for ARMv6
Message-ID: <20120620084547.GB13009@n2100.arm.linux.org.uk>
References: <CADysL2acF3ttJ-TR2as+GT66MfJiK4YyWYaAiP5j8yQ+YLBGYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADysL2acF3ttJ-TR2as+GT66MfJiK4YyWYaAiP5j8yQ+YLBGYQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 04:51:16PM +0530, Gupta, Ramesh wrote:
> >From 630a3a8f341eb7f58f9a63bf786d732b5bdfd01e Mon Sep 17 00:00:00 2001
> From: Ramesh Gupta G <grgupta@ti.com>
> Date: Fri, 15 Jun 2012 16:39:21 +0530
> Subject: [PATCH v2 2/4] ARM: add flush_mem api for ARMv6
> 
> Added flush_mem cache maintenance api for ARMv6.
> The implementation is based on dma_flush_range.

And what about all the other users of the define_cache_functions macro?

This series is incomplete, and therefore entirely unsuitable for
upstreaming.
