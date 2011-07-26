Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1GZH5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:57:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64157 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1GZH4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E2E70C3.7050306@ncos.nec.co.jp>
References: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com>
	<4E2E507F.7030607@jp.fujitsu.com>
	<CAM2zO=CGkVCMNZS8F6LxFi-NdYXf0fDLB_AEc00xrPvO_D02qw@mail.gmail.com>
	<4E2E6102.3060600@jp.fujitsu.com>
	<CAM2zO=CxriXK4bqGbwhfkfdgSpGwe1mAJE=6cYpDAf0Hxji0sQ@mail.gmail.com>
	<4E2E70C3.7050306@ncos.nec.co.jp>
Date: Tue, 26 Jul 2011 15:56:53 +0800
Message-ID: <CAM2zO=Db07v6xOkOnikNz+MYdGJWTZ9Se_dFWr+OY025OV7+yA@mail.gmail.com>
Subject: Re: [PATCH] proc/softirqs: only show state for online cpus
From: Yong Zhang <yong.zhang0@gmail.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 3:46 PM, Keika Kobayashi
<kobayashi.kk@ncos.nec.co.jp> wrote:
>
> for_each_online_cpu() was in my first patch, like /proc/softirq.
>
> But Andrew said
> --
> Probably for_each_possible_cpu() is best - people might want to see how
> many softirqs happened on a CPU which was recently offlined.
> --
> It makes sense.

Ah, thanks for the clarification.

>
> We would like to collect this information
> for trouble-shooting.
> I think for_each_possible_cpu() is better.
>
> At that time, I suggested to change
> from for_each_online_cpu() to for_each_possible_cpu(),
> in /proc/interrupts.

+1
Thus we could also avoid the issue pointed by KOSAKI Motonhiro.

>
> In conclusion, we decided to remain /proc/interrupts.
> because it had been the way for a long time.

fair enough :)
I will make a patch for /proc/interrupts instead.

Thanks,
Yong



-- 
Only stand for myself
