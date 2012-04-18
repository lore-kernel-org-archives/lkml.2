Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2DRLoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:44:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:33104 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2DRLoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:44:21 -0400
Date: Wed, 18 Apr 2012 13:44:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] Fix CONFIG_CLOCKSOURCE_WATCHDOG=n compile
In-Reply-To: <1334174480-16331-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.LFD.2.02.1204181342560.2542@ionos>
References: <1334174480-16331-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, Prarit Bhargava wrote:

> Noticed this while debugging -- compile fails with
> 
> arch/x86/built-in.o: In function `mark_tsc_unstable':
> /home/linux-2.6/arch/x86/kernel/tsc.c:791: undefined reference to
> `clocksource_mark_unstable'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Add in an empty function for the !CONFIG_CLOCKSOURCE_WATCHDOG case.

CONFIG_CLOCKSOURCE_WATCHDOG for x86 is always 'y', so what's the point?
 
Thanks,

	tglx
