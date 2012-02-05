Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2BEVyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 16:54:40 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:38677 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751704Ab2BEVyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 16:54:38 -0500
Date: Sun, 5 Feb 2012 22:11:48 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 37/49] pcmcia: irq: Remove IRQF_DISABLED
Message-ID: <20120205211148.GA13598@comet.dominikbrodowski.net>
Mail-Followup-To: Yong Zhang <yong.zhang0@gmail.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	linux-pcmcia@lists.infradead.org
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
 <1319277421-9203-38-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319277421-9203-38-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 05:56:49PM +0800, Yong Zhang wrote:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Applied, thanks.

Best
	Dominik
