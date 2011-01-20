Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1ATL5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:57:35 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44579 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1ATL5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:57:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cXhMp9IQEjkXrqtNfTlCPLOaSimuxGfr4Vl5xccfl9psEJihFnZgBa+Qg73j4H8UQ8
         TedSS4AA8P0YbmnY9e1oiwet3+Sec526iPCHgNyprCmOo8VuwNFqLLwV/u7UcvvNrAmn
         auPpQq8cxFDEV7QbWwQclvBU/zi1DXdqGYcr4=
MIME-Version: 1.0
In-Reply-To: <1295522876.28776.158.camel@laptop>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	<20110119135546.bb7e8f62.akpm@linux-foundation.org>
	<1295484358.15213.25.camel@yhuang-dev>
	<20110119165247.cca2f434.akpm@linux-foundation.org>
	<1295520247.28776.152.camel@laptop>
	<AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
	<1295522876.28776.158.camel@laptop>
Date: Thu, 20 Jan 2011 19:57:33 +0800
Message-ID: <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: huang ying <huang.ying.caritas@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 7:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-01-20 at 19:18 +0800, huang ying wrote:
>> >
>> > In fact, I have a patch ready and waiting to revert the whole irq_work
>> > stuff, that too seems to be a superfluous generalization.
>>
>> What do you plan to replace irq_work?  I plan to use it in APEI NMI
>> handler and MCE handler.
>
> But will all that stuff be accepted? Please stop sending infrastructure
> bits and focus on your larger RAS picture, once you have consensus on
> that from all parties involved, then, and only then, does it make sense
> to submit everything, including infrastructure.

I am not sending hardware error reporting infrastructure.  As far as I
know, Linus and Andrew suggest to use printk for hardware error
reporting.  And now, I just try to write APEI driver and reporting
hardware error with printk.  Is it acceptable?  Do you have some other
idea about hardware error reporting?

> As it stands now you're simply submitting infrastructure without any
> users, and we all know the RAS thing isn't settled, so those users might
> never come..

As for llist, I just want to send some code that is useful for not
only RAS users.  If it has not any user except APEI driver,  I will
move it into APEI driver code.

Best Regards,
Huang Ying
