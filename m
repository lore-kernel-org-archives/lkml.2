Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2FBOYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 10:24:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56767 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab2FBOYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 10:24:42 -0400
References: <20120601155447.GG3671@sgi.com>
In-Reply-To: <20120601155447.GG3671@sgi.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=GB2312
Message-Id: <B389EF27-033E-4452-801B-A218089C599B@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPad Mail (9B206)
From: "Ethan.kernel@gmail" <ethan.kernel@gmail.com>
Subject: Re: Commit 722bc6b167 breaks booting on an 8TB system.
Date: Sat, 2 Jun 2012 22:24:30 +0800
To: Robin Holt <holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

very interested about how long time take it to boot,
I have tested with 4TB.

Thanks for your info.

Ethan

ÔÚ 2012-6-1£¬23:54£¬Robin Holt <holt@sgi.com> Ð´µÀ£º

> I just tried to boot an 8TB system.  It fails very early in boot with:
> 
> Kernel panic - not syncing: Cannot find space for the kernel page tables
> 
> 
> A git bisect lead me to commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.
> 
> A git revert of that commit based on Linus' current as of a few hours ago
> (commit fb21aff) does boot past that point on the 8TB configuration.
> 
> Thanks,
> Robin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
