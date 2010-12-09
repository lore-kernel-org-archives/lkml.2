Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab0LIKjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:39:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38910 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab0LIKjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:39:07 -0500
Date: Thu, 9 Dec 2010 10:38:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: skannan@codeaurora.org
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Nicolas Pitre <nico@marvell.com>, linux-kernel@vger.kernel.org,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to
	early_initcall
Message-ID: <20101209103835.GA31465@n2100.arm.linux.org.uk>
References: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org> <20101202221909.GK29347@n2100.arm.linux.org.uk> <4CF94DDD.8000409@codeaurora.org> <20101203203653.GB10245@n2100.arm.linux.org.uk> <4CFDD297.4020600@codeaurora.org> <15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 01:23:24AM -0800, skannan@codeaurora.org wrote:
> Russell, Have you had a chance to look at this? Any comments? How do we
> move ahead?

I had connected the other thread with this one - it's pretty hard not
to as it included this patch in that set as the first patch.
