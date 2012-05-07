Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2EGTRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:17:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:41662 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2EGTRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:17:12 -0400
Date: Mon, 7 May 2012 21:17:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <mgalbraith@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clockevents: Per cpu tick skew boot option
In-Reply-To: <1336309127.7351.13.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1205072115000.6271@ionos>
References: <1336309127.7351.13.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2012, Mike Galbraith wrote:
>  
> +	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
> +			xtime_lock contention on larger systems.  Note: increases
> +			power consumption, and should only be enabled if running
> +			jitter sensitive (HPC/RT) workloads.
> +

The "=" is wrong as skew_tick should not take parameters. It's
disabled by default. So "skew_tick" simply enables it, right ?

