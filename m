Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab1GJJJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:09:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52522 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755513Ab1GJJJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:09:39 -0400
Date: Sun, 10 Jul 2011 18:09:30 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] Add a generic struct clk
Message-ID: <20110710090927.GA23445@opensource.wolfsonmicro.com>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <1305876469.325655.313573683829.0.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305876469.325655.313573683829.0.gpush@pororo>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:27:49PM +0800, Jeremy Kerr wrote:
> [This series was originally titled 'Add a common struct clk', but
> the goals have changed since that first set of patches. We're now aiming
> for a more complete generic clock infrastructure, rather than just
> abstracting struct clk]
> 
> [This series still needs work, see the TODO section below]

Is there a git tree with the current state of this code in it somewhere?
It's not mentioned here and my google skills are failing me.
