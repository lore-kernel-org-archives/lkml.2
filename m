Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2DTAYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:24:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29793 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2DTAYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:24:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6686"; a="183334296"
Date: Thu, 19 Apr 2012 19:24:12 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/6] hexagon: do_notify_resume() needs
 tracehook_notify_resume()
Message-ID: <20120420002412.GF5074@codeaurora.org>
References: <20120419231431.GA15820@redhat.com>
 <20120419231527.GC15828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419231527.GC15828@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 01:15:27AM +0200, Oleg Nesterov wrote:
> arch/hexagon/kernel/signal.c:do_notify_resume() forgets to call
> tracehook_notify_resume() if TIF_NOTIFY_RESUME is set.
> 
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/hexagon/kernel/signal.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 

Thanks for catching that!

Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
