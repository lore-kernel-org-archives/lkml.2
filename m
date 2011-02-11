Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1BKM5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:57:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48499 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1BKM5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:57:48 -0500
Date: Fri, 11 Feb 2011 13:57:46 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 33/75] gpio: Remove broken irq_desc hackery.
Message-ID: <20110211125746.GC2264@pengutronix.de>
References: <20110210222908.661199947@linutronix.de>
 <20110210223257.489197200@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20110210223257.489197200@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 11:37:05PM -0000, Thomas Gleixner wrote:
> No code outside of core is supposed to fiddle with this. If there is
> something missing in core, then talk to me and we'll fix it. But
> fiddling in core guts just because it can be done is a nono. Using it
> unlocked and writing a comment about it is ....

I guess including <irq.h> should go then as well?

Regards,

   Wolfram

-- 
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
