Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab1EMICa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:02:30 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:33779 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757787Ab1EMIC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:02:27 -0400
Date: Fri, 13 May 2011 09:03:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: linux-next: manual merge of the tip tree with the  tree
Message-ID: <20110513080327.GC12058@linux-mips.org>
References: <20110513131044.499e82d0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513131044.499e82d0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 01:10:44PM +1000, Stephen Rothwell wrote:

> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> arch/mips/kernel/i8253.c between commit 2b9b7cd782a5 ("clocksource:
> convert mips to generic i8253 clocksource") from the arm tree and commit
> 75c4fd8c7862 ("mips: convert to clocksource_register_hz/khz") from the
> tip tree.
> 
> The former seems to supercede the latter, so I used the former.

That's the right resolution, thanks!

  Ralf
