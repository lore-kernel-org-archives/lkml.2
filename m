Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0DJVsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 17:48:06 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:51809 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab0DJVsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 17:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k6rfDHotFBUI7ZR/c09c2yVsQStzCi242ZCZp2RIul6OHYcu7puFIvTc3N5j7FgcUO
         VPDDguBjNUZjyq/DRTuxI6+Z8XYhfxuwFpTnfi5p12jvO47+SoMbA6hdPmYaBxEwQD1E
         fkvO4RW+66tTMHe4MVmsZOGvlHxZFdW2CtReU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003220916120.3147@localhost.localdomain>
References: <201003112209.o2BM91oQ013581@imap1.linux-foundation.org>
	 <alpine.LFD.2.00.1003132039110.22855@localhost.localdomain>
	 <927ea285bd0c68934ddae1a47e44a9ba@localhost>
	 <20100322060343.3487e32c@taxman.wild-wind.fr.eu.org>
	 <alpine.LFD.2.00.1003220916120.3147@localhost.localdomain>
Date: Sat, 10 Apr 2010 14:48:02 -0700
Message-ID: <m2h5d5443651004101448xaf04b4c0lbd1f7df9b4d4ee49@mail.gmail.com>
Subject: Re: [patch 3/3] genirq: introduce IRQF_ALLOW_NESTED flag for 
	request_irq()
From: Trilok Soni <soni.trilok@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@misterjones.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, joachim.eastwood@jotron.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,
On Mon, Mar 22, 2010 at 1:17 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 22 Mar 2010, Marc Zyngier wrote:
>> > Please note that this patch has only been compile-tested, as I'm traveling
>> > for the rest of the week and don't have access to my boards.
>> >
>> > Thanks,
>> >
>> >         M.
>>
>> Any comment on this?
>
> Yes, I was traveling last week and this is in my mail backlog :)
>
> Thanks,

Any updates on this patch?


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
