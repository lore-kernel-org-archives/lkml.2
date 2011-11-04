Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1KDJx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:53:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56172 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1KDJx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <20111103133537.GA794@zverina>
References: <1320240899-16889-1-git-send-email-anarsoul@gmail.com>
 <w4ehxqf0q1.wl%peter@chubb.wattle.id.au> <20111103133537.GA794@zverina>
From: Vasily <anarsoul@gmail.com>
Date: Fri, 4 Nov 2011 12:53:34 +0300
Message-ID: <CA+E=qVenJBcSYrq4MYL6d175CtLOAT4SiG_fcMq4gBPJq=LFfA@mail.gmail.com>
Subject: Re: [PATCH RESEND] Fix reboot regression on Acer Aspire One AOA110
To: Uros Vampl <mobile.leecher@gmail.com>
Cc: Peter Chubb <peter.chubb@nicta.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/3 Uros Vampl <mobile.leecher@gmail.com>:
>>
>> Try this:
>
> Yes, this works too.

Works for me aswell.

So,

Tested-by: Vasily Khoruzhick <anarsoul@gmail.com>
