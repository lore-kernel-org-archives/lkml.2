Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1J1GR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 02:17:56 -0400
Received: from linux-sh.org ([111.68.239.195]:37911 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab1J1GRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 02:17:55 -0400
Date: Fri, 28 Oct 2011 15:17:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, linux-sh@vger.kernel.org
Subject: Re: [PATCH 16/49] SH: irq: Remove IRQF_DISABLED
Message-ID: <20111028061745.GI32187@linux-sh.org>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com> <1319277421-9203-17-git-send-email-yong.zhang0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319277421-9203-17-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 05:56:28PM +0800, Yong Zhang wrote:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Applied, thanks.
