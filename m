Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1A0HzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:55:17 -0500
Received: from www.tglx.de ([62.245.132.106]:46296 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1A0HzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:55:15 -0500
Date: Thu, 27 Jan 2011 08:54:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [patch 2/9] cris: Replace deprecated spinlock initialization
In-Reply-To: <20110124105410.GI9874@axis.com>
Message-ID: <alpine.LFD.2.00.1101270854230.31804@localhost6.localdomain6>
References: <20110123143631.392446736@linutronix.de> <20110123143837.035565371@linutronix.de> <20110124105410.GI9874@axis.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011, Jesper Nilsson wrote:

> On Sun, Jan 23, 2011 at 04:16:55PM +0100, Thomas Gleixner wrote:
> > SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
> > instead.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Mikael Starvik <starvik@axis.com>
> > Cc: linux-cris-kernel@axis.com
> 
> Thanks, I'll add this to the CRIS-tree.

I take it through core/locking in tip as well, because further
cleanups depend on it. Git will sort out the identical changes.

Thanks,

        tglx
