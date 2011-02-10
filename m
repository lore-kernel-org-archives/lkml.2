Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab1BJXyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:54:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240Ab1BJXyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:54:20 -0500
MIME-Version: 1.0
In-Reply-To: <20110210222908.661199947@linutronix.de>
References: <20110210222908.661199947@linutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Feb 2011 15:53:41 -0800
Message-ID: <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 3:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> A preview is available at:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-genirq.git irq/core

For things like this, please just always include a diffstat so that
people can tell from the email whether they care or not.

                  Linus
