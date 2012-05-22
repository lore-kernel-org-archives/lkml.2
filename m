Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab2EVRK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:10:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:39424 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2EVRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:10:55 -0400
Date: Tue, 22 May 2012 19:10:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: "David S. Miller" <davem@davemloft.net>,
        sparclinux <sparclinux@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparc32: use the common implementation of
 alloc_thread_info_node()
In-Reply-To: <20120522151123.GA10058@merkur.ravnborg.org>
Message-ID: <alpine.LFD.2.02.1205221909540.3231@ionos>
References: <20120522151123.GA10058@merkur.ravnborg.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Sam Ravnborg wrote:

> >From 52d8a6d1b81a19e693a09df90275600f44293f43 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Tue, 22 May 2012 16:39:00 +0200
> Subject: [PATCH] sparc32: use the common implementation of alloc_thread_info_node()
> 
> With sun4c removed we can fall-back to the common implementation.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> 
> This is not a "real" bug but I would like it applied anyway.
> Thomas Gleixner <tglx@linutronix.de> consolidated all
> alloc_thread_info_node() implmentations but sparc32 was
> left out due to sun4c weirdness.
> 
> With sun4c gone we can align with the rest of the world.
> (and I promised Thomas to follow-up on this when his patch-set was merged).

Thanks!

