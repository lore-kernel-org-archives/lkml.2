Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2AEPCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:02:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48907 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2AEPCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:02:03 -0500
Date: Thu, 5 Jan 2012 15:01:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: hamo.by@gmail.com
Cc: will.deacon@arm.com, marc.zyngier@arm.com, sboyd@codeaurora.org,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] arm: Define cpu_logical_map when CONFIG_SMP is not
	set
Message-ID: <20120105150140.GX11810@n2100.arm.linux.org.uk>
References: <1325767486-6392-1-git-send-email-hamo.by@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325767486-6392-1-git-send-email-hamo.by@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 08:44:46PM +0800, hamo.by@gmail.com wrote:
> From: Yang Bai <hamo.by@gmail.com>
> 
> If CONFIG_SMP is not set, define cpu_logical_map(cpu) as
> (cpu), this fixes the problem described in this mail:
> https://lkml.org/lkml/2012/1/2/142

This doesn't solve the reported problem.  asm/smp.h should not be included
by any .c file, and won't be included by linux/smp.h if CONFIG_SMP is not
set.
