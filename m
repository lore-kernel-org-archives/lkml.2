Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1FDGZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 02:25:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:56853 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab1FDGZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 02:25:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Lauss <manuel.lauss@googlemail.com>
Subject: Re: =?utf-8?b?cmN1X2t0aHJlYWQ=?= hang on 3.0.0-rc1-next-20110602
Date: Sat, 4 Jun 2011 06:17:50 +0000 (UTC)
Message-ID: <loom.20110604T081231-613@post.gmane.org>
References: <85F46CF9-5433-4623-91FC-9CD890082F69@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 188.22.154.157 (Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20110529 Firefox/4.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Markus Hästbacka <mhastbacka <at> gmail.com> writes:
> If I
> run dmesg  the computer hangs for 15 minutes, and I cannot even login at this
time, if I leave top (the top
> window updates very slowly, like every 5 minutes during this period) running I
can see that the process
> rcu_kthread takes 100% CPU, the computer load average is at around 10.

> but for example the last time I got the hang, I didn't get this error, nor any
other error for that matter.
> 
> The OS is installed on a CF-card. The computer is a eBox computer with VIA
Nehemiah CPU, 256MB RAM.
> 
> what more information do you need? Or what more can I test?

I too experience this weird 15 to 20-minute hang, but only on non-preempt
uniprocessor kernels; it still responds to pings, though.
With either preempt or SMP enabled it's not as visible or simply gone.

Manuel


