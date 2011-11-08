Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab1KHXiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:38:14 -0500
Received: from relais.videotron.ca ([24.201.245.36]:24540 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1KHXiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:38:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 08 Nov 2011 18:38:12 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v8 15/16] ARM: LPAE: add support for ATAG_MEM64
In-reply-to: <1320682618-1182-16-git-send-email-catalin.marinas@arm.com>
Message-id: <alpine.LFD.2.02.1111081832290.3307@xanadu.home>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-16-git-send-email-catalin.marinas@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Catalin Marinas wrote:

> From: Will Deacon <will.deacon@arm.com>
> 
> LPAE provides support for memory banks with physical addresses of up
> to 40 bits.
> 
> This patch adds a new atag, ATAG_MEM64, so that the Kernel can be
> informed about memory that exists above the 4GB boundary.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

NAK.  Any LPAE capable platform to come is, by definition, a new 
platform.  It therefore should be using DT upfront.


Nicolas
