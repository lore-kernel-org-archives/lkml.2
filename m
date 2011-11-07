Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab1KGCLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 21:11:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1KGCLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 21:11:03 -0500
Date: Mon, 7 Nov 2011 10:10:48 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-mips@linux-mips.org, sfr@canb.auug.org.au
Subject: Re: [PATCH 12/49] MIPS: irq: Remove IRQF_DISABLED
Message-ID: <20111107021048.GA3027@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
 <1319277421-9203-13-git-send-email-yong.zhang0@gmail.com>
 <20111104122106.GA7581@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111104122106.GA7581@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 12:21:06PM +0000, Ralf Baechle wrote:
> Thanks, queued for 3.3.  I resolved a conflict in dbdma.c and remove
> one IRQF_DISABLED which had been missed in arch/mips/kernel/perf_event.c.

Thanks, Ralf.

And FYI, my patch is based on next-20111014 when I made it.

Seems Stephen Rothwell(Cc'ing) meet some conflict. Could
you please visit it?

Thanks,
Yong
