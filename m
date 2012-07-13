Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2GMHCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 03:02:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46157 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2GMHCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 03:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAK2TD5ygowdy9t1TpfxAPbpvNQfMnMB-3Zp8TKMsTYtBZdGW=Q@mail.gmail.com>
References: <CAK2TD5ygowdy9t1TpfxAPbpvNQfMnMB-3Zp8TKMsTYtBZdGW=Q@mail.gmail.com>
Date: Fri, 13 Jul 2012 15:02:35 +0800
Message-ID: <CAFNq8R6dNb0BrDVZScJ8s=P3B-OMgtr8tUdy8XqQcCAeUWuH+A@mail.gmail.com>
Subject: Re: ARM: why smp_mb() is not needed in the "__mutex_fastpath_lock"
 and "__mutex_fastpath_unlock" functions
From: Li Haifeng <omycle@gmail.com>
To: shan kang <kangshan0910@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shan,

2012/7/12 shan kang <kangshan0910@gmail.com>:
> Hello,
>    I wonder why smp_mb() is not needed in the "__mutex_fastpath_lock"
> and "__mutex_fastpath_unlock" functions which are located in the
> "arch/arm/include/asm/mutex.h"?
>    I think "dmb" instruction is necessary there.

Why necessary? Could you explain more detailed?

>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
