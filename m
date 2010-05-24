Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0EXWCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:02:24 -0400
Received: from kroah.org ([198.145.64.141]:46895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0EXWCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:02:23 -0400
Date: Mon, 24 May 2010 14:40:29 -0700
From: Greg KH <greg@kroah.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH 1/2] posix_timer: separate timer_cleanup from
 timer_del
Message-ID: <20100524214029.GG16655@kroah.com>
References: <1273843731-12595-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273843731-12595-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 05:28:50PM +0400, Andrey Vagin wrote:
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  include/linux/posix-timers.h |    2 ++
>  kernel/posix-cpu-timers.c    |   13 ++++++++++---
>  kernel/posix-timers.c        |    4 ++++

I have no idea why this is for the -stable kernels, do you?

Please, just put a:
	Cc: stable <stable@kernel.org>
in the signed-off-by area of the patch, so that way I will be notified
when it goes into Linus's tree, not before, which just wastes my time...

thanks,

greg k-h
