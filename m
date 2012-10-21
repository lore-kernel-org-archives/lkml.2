Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab2JUOqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 10:46:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JUOqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 10:46:48 -0400
Subject: Re: irq/manage.c wrong comment( ? )
From: anish kumar <anish198519851985@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1350055963.8329.27.camel@anish-Inspiron-N5050>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
	 <alpine.LFD.2.02.1210121427490.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210121440160.2779@ionos>
	 <1350055963.8329.27.camel@anish-Inspiron-N5050>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Oct 2012 23:46:35 +0900
Message-ID: <1350830795.9435.1.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping...
On Sat, 2012-10-13 at 00:32 +0900, anish kumar wrote:?
> Hello tglx,
> 
> I just found the below inconsistency while going through the code.
> 
> 
> kernel/irq/manage.c
> 
>     if (new->flags & IRQF_ONESHOT) {
>         /*
>          * The thread_mask for the action is or'ed to
>          * desc->thread_active to indicate that the
>          * IRQF_ONESHOT thread handler has been woken, but not
>          * yet finished. The bit is cleared when a thread
>          * completes. When all threads of a shared interr
> 
> Shouldn't this "desc->thread_active" be desc->threads_active ??


