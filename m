Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1DRIa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:30:29 -0400
Received: from linux-sh.org ([111.68.239.195]:47608 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab1DRIaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:30:23 -0400
Date: Mon, 18 Apr 2011 17:29:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sh@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] kgdbts: unify/generalize gdb breakpoint adjustment
Message-ID: <20110418082900.GB32457@linux-sh.org>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <1302760895-13459-6-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302760895-13459-6-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 02:01:35AM -0400, Mike Frysinger wrote:
> The Blackfin arch, like the x86 arch, needs to adjust the PC manually
> after a breakpoint is hit as normally this is handled by the remote gdb.
> However, rather than starting another arch ifdef mess, create a common
> GDB_ADJUSTS_BREAK_OFFSET define for any arch to opt-in via their kgdb.h.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
