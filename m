Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920Ab2JLPdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:33:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45814 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2JLPdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:33:11 -0400
Subject: irq/manage.c wrong comment( ? )
From: anish kumar <anish198519851985@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1210121440160.2779@ionos>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
	 <alpine.LFD.2.02.1210121427490.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210121440160.2779@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Oct 2012 00:32:43 +0900
Message-ID: <1350055963.8329.27.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello tglx,

I just found the below inconsistency while going through the code.


kernel/irq/manage.c

    if (new->flags & IRQF_ONESHOT) {
        /*
         * The thread_mask for the action is or'ed to
         * desc->thread_active to indicate that the
         * IRQF_ONESHOT thread handler has been woken, but not
         * yet finished. The bit is cleared when a thread
         * completes. When all threads of a shared interr

Shouldn't this "desc->thread_active" be desc->threads_active ??

