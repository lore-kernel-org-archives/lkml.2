Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1EXUQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:16:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43589 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab1EXUQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:16:45 -0400
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/7] um: print info about fatal segfaults
Date: Tue, 24 May 2011 22:14:20 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.3; x86_64; ; )
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
References: <1306075716-20042-1-git-send-email-richard@nod.at> <1306075716-20042-5-git-send-email-richard@nod.at> <20110524123433.0b74f33e.akpm@linux-foundation.org>
In-Reply-To: <20110524123433.0b74f33e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105242214.21102.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 24 Mai 2011, 21:34:33 schrieb Andrew Morton:
> Please see the nice comment in printk.h
> 
> /*
>  * Please don't use printk_ratelimit(), because it shares ratelimiting
> state * with all other unrelated printk_ratelimit() callsites.  Instead
> use * printk_ratelimited() or plain old __ratelimit().
>  */
> 
> I thought we had a checkpatch rule for this but apparently I dreamed
> it.

Hmm, it seems I'm not the only one who doesn't know that. :-\
rw@raccoon:/media/data1/linux-2.6 (master)> grep * -R -e "printk_ratelimit()" | wc -l
243

Anyway, will resend...

Thanks,
//richard
