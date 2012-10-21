Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2JUBWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 21:22:18 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55192 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2JUBWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 21:22:17 -0400
X-Nat-Received: from [202.181.97.72]:61962 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1350782518.18398
To: yann.morin.1998@free.fr, benjamin.poirier@gmail.com
Cc: mmarek@suse.cz, sakiwit@gmail.com, lacombar@gmail.com, udknight@gmail.com,
        paul.gortmaker@windriver.com, dave@gnu.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        yselkowitz@gmail.com
Subject: Re: [PATCH] menuconfig: Replace CIRCLEQ by list_head-style lists.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
	<1350755792-21217-1-git-send-email-benjamin.poirier@gmail.com>
	<201210202322.07188.yann.morin.1998@free.fr>
In-Reply-To: <201210202322.07188.yann.morin.1998@free.fr>
Message-Id: <201210211021.CCC65894.VOJFFSHQMFOtOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 21 Oct 2012 10:21:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20102012 #8165821, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yann E. MORIN wrote:
> Benjamin, All,
> 
> On Saturday 20 October 2012 Benjamin Poirier wrote:
> > From: Benjamin Poirier <bpoirier@suse.de>
> > 
> > sys/queue.h and CIRCLEQ in particular have proven to cause portability
> > problems (reported on Debian Sarge, Cygwin and FreeBSD)
> > 
> > Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
> 
> Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Thank you for this patch! I guess it is the best solution we can get.
> 
> Regards,
> Yann E. MORIN.

This patch solves my problem on Debian Sarge. Thank you.

Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
