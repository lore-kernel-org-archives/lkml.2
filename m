Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1CHJFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:05:42 -0500
Received: from www.tglx.de ([62.245.132.106]:51831 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1CHJFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:05:39 -0500
Date: Tue, 8 Mar 2011 10:05:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 repost] debugobjects: print more data
In-Reply-To: <20110307085809.GA9334@redhat.com>
Message-ID: <alpine.LFD.2.00.1103081004250.2787@localhost6.localdomain6>
References: <20110307085809.GA9334@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011, Stanislaw Gruszka wrote:

> On complex subsystems like mac80211, structures may include many timers
> and works. In such case, based only on call trace and object type is
> hard to conclude where bug could possibly be.
> 
> Patch extend debug object descriptor to additional debug hint function.
> If defined, it return address, which have associated kernel symbol (i.e.
> hrtimer->function pointer). We print that symbol when bug is detected,
> to identify the object.
> 
> Patch contains debug hint methods for timer_list, work_struct
> and hrtimer.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> Cc Andrew, perhaps this could be merged through mm?

It's on my list. I just was away for a few days.

