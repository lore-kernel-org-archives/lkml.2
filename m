Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab2AYOQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:16:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:60045 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2AYOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:16:23 -0500
Date: Wed, 25 Jan 2012 15:16:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Namit Gupta <namit2010@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Removal of unwanted comment in hrtimer structure
In-Reply-To: <CAKMXDJWDx6Zef6yqJjTyCRuhSnkAfcSTEdVoJH+woOqHWttV2w@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1201251512520.2716@ionos>
References: <CAKMXDJXtUzCs2tTEGcKq+U3KwX8nMM3eYSbeUHiKwg5POiQ2nA@mail.gmail.com> <CAKMXDJWoSxnfN5c96LWPtDX0pwuHcAxy2612S=A4=GmvC-TrSQ@mail.gmail.com> <CAKMXDJWDx6Zef6yqJjTyCRuhSnkAfcSTEdVoJH+woOqHWttV2w@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012, Namit Gupta wrote:

> Dear Mr Thomas Gleixner,
> 
> While working on hrtimer, I found that the "_expires" field has been
> removed in latest kernel (kernel 3.x). but the comment written for
> "_expires" has yet not been removed.

There is no comment for the _expires field. The comment talks about
node and the struct element node.expires which replaced _expires, but
still has the same semantics as the old _expires field. So the comment
is correct and stays.

>  /**
>   * struct hrtimer - the basic hrtimer structure
> - * @node: timerqueue node, which also manages node.expires,
> - * the absolute expiry time in the hrtimers internal
> - * representation. The time is related to the clock on
> - * which the timer is based. Is setup by adding
> - * slack to the _softexpires value. For non range timers
> - * identical to _softexpires.
> + * @node: timerqueue node, which also manages node

Aside of that this comment is wrong and pointless. It says:

      @A: bla A, which also manages A

Pretty useless.

Thanks,

	tglx
