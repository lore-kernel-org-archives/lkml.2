Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0DVBhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 21:37:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:56576 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0DVBhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 21:37:37 -0400
Date: Thu, 22 Apr 2010 09:37:21 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded irq handler question
Message-ID: <20100422013721.GC8938@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Apr 2010 01:37:23.0845 (UTC) FILETIME=[5B7C3B50:01CAE1BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 05:35:32PM +0100, Will Newton wrote:
> Hi all,
> My problem is that this structure does not work, because once I call
> disable_irq_nosync() on the irq in the check handler the thread will
> no longer run because the irq is disabled. However if I don't call
> disable_irq_nosync() I will get endless irqs because the line is
> level-triggered and will not be deasserted until the thread has run.
> 
> Could someone tell me what I'm doing wrong here?

Does IRQF_ONESHOT meet your need?

Thanks,
Yong
