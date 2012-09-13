Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab2IMQ5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:57:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56177 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2IMQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:57:41 -0400
Date: Thu, 13 Sep 2012 09:55:05 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH v7 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120913165505.GA6517@lizard>
References: <20120913150133.GA16238@lizard>
 <20120913180457.1396637b@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120913180457.1396637b@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 06:04:57PM +0100, Alan Cox wrote:
> On Thu, 13 Sep 2012 08:01:33 -0700
> Anton Vorontsov <anton.vorontsov@linaro.org> wrote:
> 
> > Hi all,
> > 
> > Here comes the lucky v7:
> > 
> > - Per Alan Cox's suggestion added hangup method and removed a small
> >   leftover;
> > - Per Colin Cross' suggestion moved IRQ quiescing logic into
> >   poll_get_char routine. IIUC, Alan is less unhappy about it.  As a
> >   result, clear_irq() callback dropped.
> 
> Ok that has my ack. Some of it is not pretty but debugger hooks that
> have to run behind the OS while debugging it never are.
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

Great! Much thanks for reviews, Alan.
