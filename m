Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2EEKyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:54:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:60905 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab2EEKyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:54:49 -0400
Date: Sat, 5 May 2012 12:54:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Howells <dhowells@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch V2 03/31] task_allocator: Use config switches instead of
 magic defines
In-Reply-To: <13401.1336152505@redhat.com>
Message-ID: <alpine.LFD.2.02.1205051254140.6271@ionos>
References: <20120503085034.032327158@linutronix.de> <20120503083859.991965503@linutronix.de> <13401.1336152505@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2012, David Howells wrote:

> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > +config ARCH_TASK_STRUCT_ALLOCATOR
> > +	bool
> > +
> > +config ARCH_THREAD_INFO_ALLOCATOR
> > +	bool
> 
> With comments saying what they mean...

Right. I dropped that patch anyway as it's incomplete. Next series
will have it proper.

Thanks,

	tglx
