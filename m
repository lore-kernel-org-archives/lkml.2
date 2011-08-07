Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1HGKoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 06:44:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62713 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1HGKoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 06:44:10 -0400
MIME-Version: 1.0
In-Reply-To: <CANqCtQLjy4Ez9D9yH9gJ_h026ThEWOYeQGrosOrSAMsnvx5HPg@mail.gmail.com>
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
	<CANqCtQ+VhmfpNZ8Oh_0MR+bZfAeBuowBsK9TyC5iA4B2oLpXfg@mail.gmail.com>
	<CANqCtQLjy4Ez9D9yH9gJ_h026ThEWOYeQGrosOrSAMsnvx5HPg@mail.gmail.com>
Date: Sun, 7 Aug 2011 12:44:08 +0200
X-Google-Sender-Auth: ynrtGrOvrjtE4qZiooEwSXXV-Ls
Message-ID: <CANqCtQ+Jg0GA8eP8DMveVQ0VXBR4odLXH1dmHnt8YT4qNSsi1g@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt6
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

2011/7/30 Remy Bohmer <linux@bohmer.net>:
> Hi,
>
> 2011/7/30 Remy Bohmer <linux@bohmer.net>:
>>> Please keep on testing and sending patches. Peter Zijlstra kindly
>>> volunteered to cover for me. He'll pick up stuff and eventually push
>>> out releases when a reasonable number of sane patches hits his inbox.
>>
>> I got rt5 booting yesterday on a ARM core (Atmel AT91):

After fixing several problems in mainstream kernel for this board
(at91sam9261ek), the RT(8) patch runs remarkably stable. None of the
problems discovered so far were related to the RT-patch. I can now
start testing how it behaves on timing level.

Thanks.

Kind regards,

Remy
