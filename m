Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1ATMt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:49:26 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37952 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1ATMtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pUrQbOlGUS1bxiHojZtXIVLv7sL1k5uFAD7DSzFNG6HZXCpPXFZrUR4WiE9Qr0L3Xw
         TYKywpXdj2nM/zhjTOTF7foUBeEHp198pB/R21IjZVwYqK0xppcYc7df5HbPj8RkWWnl
         E/tDqGslSNgVd/e6ZnmQ3a1ldrz36deC9Mucw=
MIME-Version: 1.0
In-Reply-To: <20110120121455.GA7680@elte.hu>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	<20110119135546.bb7e8f62.akpm@linux-foundation.org>
	<1295484358.15213.25.camel@yhuang-dev>
	<20110119165247.cca2f434.akpm@linux-foundation.org>
	<1295520247.28776.152.camel@laptop>
	<AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
	<1295522876.28776.158.camel@laptop>
	<AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
	<20110120121455.GA7680@elte.hu>
Date: Thu, 20 Jan 2011 20:49:23 +0800
Message-ID: <AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: huang ying <huang.ying.caritas@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 8:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * huang ying <huang.ying.caritas@gmail.com> wrote:
>
>> > But will all that stuff be accepted? Please stop sending infrastructure bits and
>> > focus on your larger RAS picture, once you have consensus on that from all
>> > parties involved, then, and only then, does it make sense to submit everything,
>> > including infrastructure.
>>
>> I am not sending hardware error reporting infrastructure.  As far as I know, Linus
>> and Andrew suggest to use printk for hardware error reporting.  And now, I just
>> try to write APEI driver and reporting hardware error with printk.  Is it
>> acceptable?  Do you have some other idea about hardware error reporting?
>
> Erm, how could you possible have missed the perf based RAS daemon work of Boris,
> which we've pointed out about half a dozen times already?

Even if there is some other hardware error reporting infrastructure
such as perf based, I think we still need printk too. After all, as
Linus pointed out, printk is the most popular error reporting
mechanism so far. Do you think so?

Best Regards,
Huang Ying
