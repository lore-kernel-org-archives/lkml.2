Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1DUOR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:17:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1DUOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:17:27 -0400
Subject: Re: [PATCH] sched: try to fix mm leak when freeing sched groups
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTinYu00M9No_Pqxp+gpEZAmPJPDt1g@mail.gmail.com>
References: <BANLkTin_m2Ygnr8csKo6fJZ4sB6YYvYDGw@mail.gmail.com>
	 <1303393450.2035.142.camel@laptop>
	 <BANLkTinYu00M9No_Pqxp+gpEZAmPJPDt1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 16:20:03 +0200
Message-ID: <1303395603.2035.144.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 21:46 +0800, Hillf Danton wrote:
> 
> It is linux-2.6.39-rc1.tar.bz2 downloaded at kernel.org, and
>           >> --- a/kernel/sched.c  2011-03-30 03:09:48.000000000 +0800
> is the time stamp, right? 

Dunno, but 39-rc1 is like ancient, please send patches against the tip
git tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

