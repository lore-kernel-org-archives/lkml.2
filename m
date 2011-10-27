Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1J0A73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:59:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45958 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1J0A71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:59:27 -0400
MIME-Version: 1.0
In-Reply-To: <CABeCy1Y_OXPJkca6dRvK4-PCfKH8wD_2Aq-9r-JyBBSCetrsOw@mail.gmail.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	<CAGjg+kH577VE4cyq5zVNR962S6xbGCNnGS0w6N1DVuOppL3Khw@mail.gmail.com>
	<CABeCy1Y_OXPJkca6dRvK4-PCfKH8wD_2Aq-9r-JyBBSCetrsOw@mail.gmail.com>
Date: Thu, 27 Oct 2011 08:59:27 +0800
Message-ID: <CAGjg+kH=QkZuxuYXAbpp3AjGVYcRfeAnSJd39jZ+k28Bze3f9g@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: alex shi <lkml.alex@gmail.com>
To: Venki Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>,
        alex.shi@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hi, venki, what version of thia patch against? I want to test the
>> power consumption for your patch.
>
> Hi Alex,
>
> It should apply cleanly over 3.0. Thanks for testing the patch..
>

Sorry still can not apply the patch on 3.0 kernel, and seems 3.0
kernel is too old. :)
---
[alexs@lkp-os linux-2.6]$ git am
~/Fwd\:_\[RFC\]_Introduce_greedy_hrtimer_walk_on_idle
Applying: Introduce greedy hrtimer walk on idle
fatal: corrupt patch at line 46
Patch failed at 0001 Introduce greedy hrtimer walk on idle
When you have resolved this problem run "git am --resolved".
---

Could you like to resend it against 3.1 kernel and cc to alex.shi@intel.com ?
