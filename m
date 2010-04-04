Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab0DDI24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 04:28:56 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:34153 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0DDI2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 04:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BqJ6Stnc63RPEHKs7J/cVAaqVZ5fhKHiihHZWHzjy17Bd5HigjV6XA8WFQKpgHLEdx
         L60UNEAjYf9OcEVXMxJY2wDcC0kTNv5oqHZLHkm1e7a5YtvwGB7GH+X9lWMrRnPK0T6i
         6aq7TLhO1sD9znNoEYR6mePmWEmt4/ABF5zBU=
MIME-Version: 1.0
In-Reply-To: <201004040349.28840.dhazelton@enter.net>
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
	 <k2tc58e39921004032226ze2eb64dev21f8c2d137a49ebc@mail.gmail.com>
	 <s2mc58e39921004032233rfd47a83eoa86b37ffe59d2e7@mail.gmail.com>
	 <201004040349.28840.dhazelton@enter.net>
Date: Sun, 4 Apr 2010 16:28:45 +0800
X-Google-Sender-Auth: 98af69473eb782fd
Message-ID: <k2rc58e39921004040128m1774f406k76bded10260c74b5@mail.gmail.com>
Subject: Re: Can we remove the Zone_DMA?
From: tek-life <teklife.kernel@gmail.com>
To: dhazelton@enter.net, oliver@neukum.org, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your replys.
I was confused. The motherboard of  Intel i810 chipset in early 1999
had not supported the ISA. You say keyboard should use ISA, what
should work for the pc using the i810 motherboard. More important ,
the keyboard don't use DMA.

2010/4/4, Daniel Hazelton <dhazelton@enter.net>:
> On Sunday 04 April 2010 01:33:09 am tek-life wrote:
>> Thanks for your reply.And do you means that , If I use a modern PC,such
>> as
>> my pc (CPU:Intel dual-core 2.6GHZ; Memory 2GB; And no pci ).I can remove
>> the ZONE_DMA .And make sure this system also run smoothly as before?
>
> *MAYBE* - if you don't use parallel ports, floppy drives or similar. There
> actually are still a lot of devices that use the ISA bus in a modern PC -
> even
> the keyboard (well, not USB ones) is an ISA device.
>
> Simple fact is that if it was possible to configure it out and not cause
> massive problems somebody would have already spun out a patch to allow just
>
> that.
>
> DRH
>
>> 在 2010年4月4日 下午1:07，Daniel Hazelton <dhazelton@enter.net>写道：
>>
>> On Sunday 04 April 2010 12:21:54 am tek-life wrote:
>> > > I’m a newbie on the linux kernel. Now I am reading the source code of
>> > > Linux . I have a question in the following about ZONE_DMA.
>> > >
>> > >
>> > > In Linux , The Memory is divided to three zone. They are ZONE_DMA
>> > > 、ZONE_NORMAL  and ZONE_HIGHMEM. From the book of "Undstand the Linux
>> > > kernel ", the ZONE_DMA has the effect that the Direct Memory Access
>> > > (DMA) processors for old ISA buses have a strong limitation: they are
>> > > able to address only the first 16 MB of RAM. SO ,we must set a zone
>> > > for  the DMA on ISA bus.  And I suspect that the hardware has
>> > > developed so quickly .And  in this days the ISA has been weeded out.
>> > > And so ,if we not defined the ZONE_DMA, is the system be effected?
>> > > And
>> > > why not remove ZONE_DMA from the kernel . If it cann‘t to do so，the
>> > > compatibility is the only reason?
>> >
>> > While ISA is gone as a true peripheral interconnect for new systems it
>> > does,
>> > actually, still live on in a lot of systems that Linux still supports.
>> > While
>> > those systems, generally, are running the same kernel and userspace
>> > they
>> > were
>> > a decade ago I have no doubt that somebody might find an old machine
>> > and
>> > put
>> > Linux on it - just because they could.
>> >
>> > And that also discounts the non-IBM PC machines that are out there that
>> > Linux
>> > also supports. While I don't know enough about them to say for sure, I
>> > am
>> > quite certain that at least some of them are still using the ISA bus.
>> >
>> > DRH
>


-- 
Laboratory of Service Computing Technology and System

p-web:http://tek-life.org/blog
QQ:150439216
