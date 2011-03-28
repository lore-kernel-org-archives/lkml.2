Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1C1U3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:29:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:36313 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1C1U3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:29:16 -0400
Date: Mon, 28 Mar 2011 22:29:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>, x86@kernel.org
Subject: Re: [GIT pull] irq cleanups for .39
In-Reply-To: <alpine.LFD.2.00.1103282210590.2774@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1103282227510.2774@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103282048370.2774@localhost6.localdomain6> <AANLkTintrwhwbyZGxX1Eecg9ZXo+NgRzTwyyMyzt1JGR@mail.gmail.com> <alpine.LFD.2.00.1103282210590.2774@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Thomas Gleixner wrote:
> 2) msg ids are unique and can ge grepped for. also there are archives
>    which allow searching for them.
> 
>    http://marc.info?i=alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6
> 
>    http://mid.gmane.org/alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6

So perhaps we should add one of those into the LKML-Reference and let
the commit bot extract the thread reference from there.

hpa ???

Thanks,

	tglx
