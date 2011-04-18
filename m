Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab1DRQR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:17:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:53087 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1DRQRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:17:24 -0400
Date: Mon, 18 Apr 2011 18:17:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON report from clockevents_program_event
In-Reply-To: <20110418161238.GB1903@redhat.com>
Message-ID: <alpine.LFD.2.00.1104181816110.2744@localhost6.localdomain6>
References: <20110417182958.GA1821@redhat.com> <alpine.LFD.2.00.1104180934010.2744@localhost6.localdomain6> <20110418161238.GB1903@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011, Dave Jones wrote:
> On Mon, Apr 18, 2011 at 09:35:19AM +0200, Thomas Gleixner wrote:
>  > > hrtimer: interrupt took 47180328 ns
>  > 
>  > Huch, what did you do to make the timer interrupt run 47ms ? There is
>  > something badly wrong.
> 
> This is probably a 'root shot himself in the foot' thing.
> 
> I ran my system call fuzzer from a wrong shell, which was a very bad idea.
> (It seems to have actually destroyed the hardware, no longer even POSTs. oops).

Yikes. That's scary. Did you end up injecting malicious microcode ?
