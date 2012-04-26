Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab2DZAGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:06:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:42119 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab2DZAG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:06:29 -0400
Date: Thu, 26 Apr 2012 02:06:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
cc: Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH][TRIVIAL] mfd: twl6030: Add intermediate cast to uintptr_t
 before casting to pointer.
In-Reply-To: <1335396750-18950-1-git-send-email-krzysztof.wilczynski@linux.com>
Message-ID: <alpine.LFD.2.02.1204260203160.2542@ionos>
References: <1335396750-18950-1-git-send-email-krzysztof.wilczynski@linux.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1926140714-1335398782=:2542"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1926140714-1335398782=:2542
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 26 Apr 2012, Krzysztof Wilczynski wrote:

> This is to address the following warning during compilation time:
> 
>   drivers/mfd/twl6030-irq.c: In function ‘twl6030_init_irq’:
>   drivers/mfd/twl6030-irq.c:398: warning: cast to pointer from integer of different size
>   drivers/mfd/twl6030-irq.c:415: warning: cast to pointer from integer of different size

Sigh. Instaed of blindy fixing some random warning, that driver should
be converted to use proper threaded interrupt handlers which already
do the Right Thing.
 
Thanks,

	tglx
--8323328-1926140714-1335398782=:2542--
