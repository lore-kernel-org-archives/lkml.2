Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2BHCdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:33:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab2BHCdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:33:32 -0500
Date: Tue, 7 Feb 2012 18:34:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] leds-lm3530: support pwm input mode
Message-Id: <20120207183413.c480fc61.akpm@linux-foundation.org>
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812ED49C6@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812ED44A8@EXMAIL03.scwf.nsc.com>
	<20120207145458.6397d04c.akpm@linux-foundation.org>
	<B567DBAB974C0544994013492B949F8E3812ED49C6@EXMAIL03.scwf.nsc.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012 16:32:14 -0800 "Kim, Milo" <Milo.Kim@ti.com> wrote:

> > lm3530_mode_set() has no local variable "pwm" and has no local variable
> > "brightness".
> 
> Local variable "pwm" was added in this patch.
> [PATCH v4 3/5] leds-lm3530: support pwm input mode
> 

hm, so it was.  Sorry, I must have lost that bit when fixing rejects.

I shall fix things up...
