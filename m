Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1HMOeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:34:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55663 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1HMOeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:34:12 -0400
Date: Sat, 13 Aug 2011 15:33:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 02/16] ARM: LPAE: Cast the dma_addr_t argument to
	unsigned long in dma_to_virt
Message-ID: <20110813143358.GO4775@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com> <1312988619-16804-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312988619-16804-3-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:03:25PM +0100, Catalin Marinas wrote:
> This is to avoid a compiler warning when invoking the __bus_to_virt()
> macro. The dma_to_virt() function gets addresses within the 32-bit
> range.

Ok.
