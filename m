Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0CTCFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 22:05:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48691 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0CTCFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 22:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XAD5OKwC+98JARUHFWskAYWWsMKxmsoC75ScGvwJurcOYWgcCC8GDRpIbfDJxpPUzV
         ccQJa1oy6PqR3fUy1UYA6PBENGUh2HYyKbZ4NcVYf0Vei2QWvSWqGrhyySL34dpMMLdv
         WhbgztGhm9CmjV0ax31+3jeHi0O0wR+eleOYM=
MIME-Version: 1.0
In-Reply-To: <20100318140630.f6768ee8.akpm@linux-foundation.org>
References: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com>
	 <aa4c40ff1003081313s7492513bk14a48c6097b90407@mail.gmail.com>
	 <4B95B028.3050106@gmail.com>
	 <aa4c40ff1003082115x3e9e1492je90e5afb826b3408@mail.gmail.com>
	 <20100309141552.GD30538@centrinvest.ru>
	 <8DFD46FA-A938-41D6-97EC-F6E5324C9FAA@gmail.com>
	 <20100311134508.GB29239@centrinvest.ru>
	 <20100318140630.f6768ee8.akpm@linux-foundation.org>
Date: Fri, 19 Mar 2010 19:05:38 -0700
Message-ID: <aa4c40ff1003191905v30b41899pc9ee07892fd56b97@mail.gmail.com>
Subject: Re: SIIG DP CyberSerial 4S PCIe Support
From: James Lamanna <jlamanna@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Panin <pazke@centrinvest.ru>, Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 2:06 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 11 Mar 2010 16:45:08 +0300
> "Andrey Panin" <pazke@centrinvest.ru> wrote:
>
>> On 068, 03 09, 2010 at 07:09:21AM -0800, James Lamanna wrote:
>> > On Mar 9, 2010, at 6:15, "Andrey Panin" <pazke@centrinvest.ru> wrote:
>> >
>> > >On 067, 03 08, 2010 at 09:15:26PM -0800, James Lamanna wrote:
>> > >
>> > >>That's probably the case.
>> > >>It looks like 8250 doesn't know about this PCIe device at all.
>> > >>The Oxford PCI ID is not in pci_ids.h nor is the SIIG subsystem ID.
>> > >>I'll see if I can maybe work up a patch to support this device,
>> > >>since I've found
>> > >>the datasheet for the Oxford 4 port UART controller, but I may
>> > >>need some help.
>> > >>Or if anyone else (who has more experience with this) wants to
>> > >>formulate one,
>> > >>it would be greatly appreciated.
>> > >
>> > >Looks like you card can use existing code for Oxford Semiconductor
>> > >UARTs.
>> > >Can you test the attached patch for 2.6.33 ?
>> >
>> > Hi Andrey,
>> > Coincidentally I found your patch for 2.6.28 that I was able to
>> > backport to 2.6.24. The card seems to be working great!
>> > Is this patch in mainline now?
>>
>> Now I'm confused, because I can't remember SIIG related patches for 2.6.28.
>
> I'm confused too.  If someone had a patch which they think needs to be
> applied, please resend it?

I believe this was the patch/diff that I saw:
http://www.linuxhq.com/kernel/v2.6/28/drivers/serial/8250_pci.c

So, from that, it looks like everything is in mainline. I had been
working with 2.6.24, which didn't have support.

-- James
