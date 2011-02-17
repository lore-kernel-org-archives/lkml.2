Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1BQPB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:01:27 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:55971 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab1BQPBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:01:24 -0500
Message-ID: <4D5D383A.6000503@free.fr>
Date: Thu, 17 Feb 2011 16:01:14 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yong Zhang <yong.zhang0@gmail.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: WARNING: at kernel/lockdep.c:2323 trace_hardirqs_on_caller+0xb9/0x16c()
References: <4D5A90D0.9040403@free.fr> <AANLkTimvue3JbYZUMrt0KppE1f_MNSsyyb+Upbputs=5@mail.gmail.com> <20110216.180347.71107177.davem@davemloft.net> <AANLkTim4NnyyFqprBoGpimquLP=6fjAanCrbqX=RXwC9@mail.gmail.com> <20110217112842.GS19830@htj.dyndns.org> <4D5D0FFC.40509@free.fr> <20110217125443.GU19830@htj.dyndns.org>
In-Reply-To: <20110217125443.GU19830@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 01:54 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Feb 17, 2011 at 01:09:32PM +0100, Daniel Lezcano wrote:
>> I applied these patches to linux-next and I blindly fixed some
>> minors conflicts. AFAICT, the problem does no longer occur and it
>> seems the patches fix the problem. I am not sure I resolved the
>> conflict correctly as I know nothing about this subsystem. Shall I
>> resend these patches for inclusion and you check they are correct ?
> The posted patches are on top of the mainline and the conflicts
> against linux-next should be minor.  I'm waiting for Jens to pick up
> the patches.

Great ! Thanks Tejun.

   -- Daniel

