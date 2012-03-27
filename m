Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2C0M7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:59:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:33526 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2C0M7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:59:08 -0400
Date: Tue, 27 Mar 2012 14:58:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <JBeulich@suse.com>
cc: mingo@elte.hu, hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: hpet_disable() call sites
In-Reply-To: <4F719449020000780007B0CD@nat28.tlf.novell.com>
Message-ID: <alpine.LFD.2.02.1203271457460.2542@ionos>
References: <4F719449020000780007B0CD@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Jan Beulich wrote:
> up kernel has a problem if the HPET is in an unexpected state, in
> particular preventing "normal" timer interrupts from occurring (which
> was in particular found to be the case during kdump attempts after
> Xen was running).

What's Xen doing special with the hpet ?
 
> Is there any reason why hpet_disable() should not also be called
> from (or some equivalent action be taken, perhaps including clearing
> certain bits in the individual counters' configuration registers, which
> are apparently - but perhaps wrongly - implied to be clear in e.g.
> hpet_set_mode(), in) hpet_enable()?

No, there is no particular reason why we don't clear those registers.

Thanks,

	tglx
