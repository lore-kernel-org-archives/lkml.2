Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1C1UHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:07:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:56196 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab1C1UHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:07:52 -0400
Date: Mon, 28 Mar 2011 22:07:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] irq updates for .39
In-Reply-To: <alpine.LFD.2.00.1103282050100.2774@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1103282206580.2774@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103282050100.2774@localhost6.localdomain6>
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

> Linus,
> 
> Please pull the latest irq-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Can you please discard this pull request. We found a non x86 wreckage
which needs to be investigated.

Thanks,

	tglx
