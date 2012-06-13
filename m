Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2FMW0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:26:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2FMW0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:26:04 -0400
Date: Wed, 13 Jun 2012 15:25:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        grant.likely@secretlab.ca, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH 01/14] rtc: ab8500-rtc: IRQF_ONESHOT when requesting a
 threaded IRQ
Message-Id: <20120613152558.e6025b04.akpm@linux-foundation.org>
In-Reply-To: <4FD70481.6020207@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-2-git-send-email-lee.jones@linaro.org>
	<201206111531.20468.arnd@arndb.de>
	<4FD70481.6020207@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012 09:57:37 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.

What does this mean.  The kernel crashes?  The registration fails?  A
warning is emitted?

When fixing a bug, please fully describe the consequences of that bug.

> Cc: stable@vger.kernel.org

Especially when suggesting a -stable backport.
