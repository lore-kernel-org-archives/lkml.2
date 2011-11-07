Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1KGDGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 22:06:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47613 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1KGDGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 22:06:20 -0500
Date: Mon, 7 Nov 2011 11:06:03 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, tglx@linutronix.de
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 12/49] MIPS: irq: Remove IRQF_DISABLED
Message-ID: <20111107030603.GA3893@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
 <1319277421-9203-13-git-send-email-yong.zhang0@gmail.com>
 <20111104122106.GA7581@linux-mips.org>
 <20111107021048.GA3027@zhy>
 <20111107134912.0878664493f1110ceefb98a6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111107134912.0878664493f1110ceefb98a6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:49:12PM +1100, Stephen Rothwell wrote:
> Hi Yong,
> 
> On Mon, 7 Nov 2011 10:10:48 +0800 Yong Zhang <yong.zhang0@gmail.com> wrote:
> >
> > On Fri, Nov 04, 2011 at 12:21:06PM +0000, Ralf Baechle wrote:
> > > Thanks, queued for 3.3.  I resolved a conflict in dbdma.c and remove
> > > one IRQF_DISABLED which had been missed in arch/mips/kernel/perf_event.c.
> > 
> > And FYI, my patch is based on next-20111014 when I made it.
> 
> You should never base anything on top of a linux-next tree.  You should
> use the tree you are fixing (Linus' or the Mips tree or ...) as the base.

Thanks for your reminding Stephen :)

So I guess 'basing on linux-next' also brings some trouble to tglx,
which is hard for him to pick them up.

I think I should base my patch on -tip for the leftovers, tglx?
Or let me know your opinion if you have different idea.

Thanks,
Yong
