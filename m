Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2FNH24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:28:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2FNH2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:28:54 -0400
Date: Thu, 14 Jun 2012 00:30:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        grant.likely@secretlab.ca, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH 01/14] rtc: ab8500-rtc: IRQF_ONESHOT when requesting a
 threaded IRQ
Message-Id: <20120614003006.68d77b37.akpm@linux-foundation.org>
In-Reply-To: <4FD98F69.3010302@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-2-git-send-email-lee.jones@linaro.org>
	<201206111531.20468.arnd@arndb.de>
	<4FD70481.6020207@linaro.org>
	<20120613152558.e6025b04.akpm@linux-foundation.org>
	<4FD98F69.3010302@linaro.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 08:14:49 +0100 Lee Jones <lee.jones@linaro.org> wrote:

> On 13/06/12 23:25, Andrew Morton wrote:
> > On Tue, 12 Jun 2012 09:57:37 +0100
> > Lee Jones<lee.jones@linaro.org>  wrote:
> >
> >> The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.
> >
> > What does this mean.  The kernel crashes?  The registration fails?  A
> > warning is emitted?
> >
> > When fixing a bug, please fully describe the consequences of that bug.
> >
> >> Cc: stable@vger.kernel.org
> >
> > Especially when suggesting a -stable backport.
> 
> No problem. I'll try to remember that for next time.
> 
> I see that you've taken the patch into your tree however. So do you want 
> me to update the commit log and resubmit, or are you going to 'let this 
> one slide'?

Please read my emails - they're very nice!  "What does this mean.  The
kernel crashes?  The registration fails?  A warning is emitted?".  You
answer that, I copy-n-paste into changelog and we're done.
