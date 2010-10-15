Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0JORNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:13:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:51479 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab0JORNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JSelS9LWuaRkrCjDfXAU3zjkg4GNJy+V82e1DWQvvdDt4KJ6htzIdCfPlTXQcUj8os
         LDN/DB8T3VLXL7VIQjfA==
MIME-Version: 1.0
In-Reply-To: <1287156451.29097.1531.camel@twins>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	<1287155513.29097.1526.camel@twins>
	<1287156451.29097.1531.camel@twins>
Date: Fri, 15 Oct 2010 10:13:46 -0700
Message-ID: <AANLkTinL=FEo9wAaUQ8p6ton+eQxLk1m2BEj-3sof3H+@mail.gmail.com>
Subject: Re: Proper kernel irq time accounting -v4
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 8:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-10-15 at 17:11 +0200, Peter Zijlstra wrote:
>> OK, I'll take this, but will frob 4 to simply add PF_KSOFTIRQD.
>>
>> We can do all additional changes, possibly including what Eric
>> suggested, at a later stage as increments.
>>
>> Thanks!
>
> *kablam!*
>
> booting with noirqtime doesn't work either, same explosion.

This crash seems to be from patch 8/8 that changed irq_enter. Please
drop it for now and I will rework that.
I will also send the cleanup changes including one that Eric suggested
as incremental patches.

Thanks,
Venki
