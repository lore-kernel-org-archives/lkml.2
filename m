Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0KSNHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:07:02 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40721 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0KSNG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XFhUsnHWFlMTCAge/J3Fa0lKYbZ78lZ7bYPwaIfSoPOtroyvT4zlWOmpF7oERvwNsd
         vbTZ+YQlWkxFpVEBCmasLsr7wknO8xvfJlSiCbmzStK9TwB165L2VNkpXwXlho+ZIyIi
         gfyn1OK01CEujYPLkRklipqCg+R7KHYhoQIEc=
MIME-Version: 1.0
In-Reply-To: <1290171315.2109.1577.camel@laptop>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<1290165768.2109.1537.camel@laptop>
	<AANLkTik3ujs7-tMNUuk33wuMXFm+iusspMcR=yjPXtn_@mail.gmail.com>
	<1290168173.2109.1565.camel@laptop>
	<AANLkTinrk8XN9XQeM-pmqhiz=tSw4x01JaGMjdRG52dF@mail.gmail.com>
	<1290171315.2109.1577.camel@laptop>
Date: Fri, 19 Nov 2010 21:06:58 +0800
Message-ID: <AANLkTikRwZzyCcNGoi0JWeDkCP71qgzUi=UvqYvdffR6@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: huang ying <huang.ying.caritas@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 8:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-11-19 at 20:48 +0800, huang ying wrote:
>>
>> I have talked with Mauro during LPC. We all agree that we need a
>> generic hardware error reporting interface. And now, I want to talk
>> with all interested parties with code.
>
> talking with code could maybe be done.. but definitely not in the form
> of a 'pull' request of your approach.
>
> Also, I would think that if you do a RFC (the usual way to talk with
> code) is to list the various requirements and how you address them with
> your code and asking the other parties if the agree with the approach
> you've taken.

I lists the requirements and my solutions in my patch description of
[1/2] and [2/2]. If you have any question, please let me know.

Best Regards,
Huang Ying
