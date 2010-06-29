Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0F2Mok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:44:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44104 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab0F2Moi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eNb1QrAhhJn+ZeicGWYD9obMK3xWuAddWlcF0gScZwi/W1dXj17XXiwugAXC6YaKtk
         PSucA4B/HIXjogTioLR+fGe8vXJEv5WjKtS+/wRBGr2siGhDpZIl9Q27Zg32VJaYQ1NW
         YUHeRV/HtBn0AXy13z+GNpNvr03r8c1o1gLI8=
MIME-Version: 1.0
In-Reply-To: <1277811316.1868.40.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	<1277808215.1868.5.camel@laptop>
	<AANLkTik4PXpgkc_ob-INohfmlTwe3wqDmif_ohXBxHHX@mail.gmail.com>
	<1277811316.1868.40.camel@laptop>
Date: Tue, 29 Jun 2010 20:44:37 +0800
Message-ID: <AANLkTil26yR6bdPoaH84rOoJfmg8cyS0ScvVeBydZQ25@mail.gmail.com>
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in 
	kernel/sched_fair.c
From: shenghui <crosslonelyover@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/29 Peter Zijlstra <peterz@infradead.org>:
> Pretty much everywhere, if you look at sched.c the only sched_class
> method not called with rq->lock held is ::task_fork().
>
> The interesting bits are that schedule()->pre_schedule()/idle_balance()
> can drop rq->lock as well as ->select_task_rq().
>
>
>
>

Thanks for your instructions!


-- 


Thanks and Best Regards,
shenghui
