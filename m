Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1AXKyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:54:13 -0500
Received: from ra.se.axis.com ([195.60.68.13]:58072 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab1AXKyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:54:12 -0500
Date: Mon, 24 Jan 2011 11:54:11 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [patch 2/9] cris: Replace deprecated spinlock initialization
Message-ID: <20110124105410.GI9874@axis.com>
References: <20110123143631.392446736@linutronix.de> <20110123143837.035565371@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123143837.035565371@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 04:16:55PM +0100, Thomas Gleixner wrote:
> SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
> instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: linux-cris-kernel@axis.com

Thanks, I'll add this to the CRIS-tree.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
