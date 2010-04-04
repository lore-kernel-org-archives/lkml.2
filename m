Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab0DDFdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 01:33:17 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:52837 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0DDFdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 01:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fNfln1nviekD13NbBZzqUvEyIx878b3ztfZ6G1ii8l+QtNQSUdWgAYx3/gExo4qNLk
         ZUfGaBIM1QnLyY7Dh4dSZVypHwrzWclxvFtO2mAwTB31Z7JLmaT1UuT9QsOiJJpY/aEa
         Btso9WwaROVEPQYVGM7Ssl+GxkSjJRPZH4Yx8=
MIME-Version: 1.0
In-Reply-To: <k2tc58e39921004032226ze2eb64dev21f8c2d137a49ebc@mail.gmail.com>
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
	 <201004040107.15783.dhazelton@enter.net>
	 <k2tc58e39921004032226ze2eb64dev21f8c2d137a49ebc@mail.gmail.com>
Date: Sun, 4 Apr 2010 13:33:09 +0800
X-Google-Sender-Auth: 2508f8d0b896fc19
Message-ID: <s2mc58e39921004032233rfd47a83eoa86b37ffe59d2e7@mail.gmail.com>
Subject: Fwd: Can we remove the Zone_DMA?
From: tek-life <teklife.kernel@gmail.com>
To: dhazelton@enter.net
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply.And do you means that , If I use a modern PC,such as
my pc (CPU:Intel dual-core 2.6GHZ; Memory 2GB; And no pci ).I can remove the
ZONE_DMA .And make sure this system also run smoothly as before?

在 2010年4月4日 下午1:07，Daniel Hazelton <dhazelton@enter.net>写道：

On Sunday 04 April 2010 12:21:54 am tek-life wrote:
> > I’m a newbie on the linux kernel. Now I am reading the source code of
> > Linux . I have a question in the following about ZONE_DMA.
> >
> >
> > In Linux , The Memory is divided to three zone. They are ZONE_DMA
> > 、ZONE_NORMAL  and ZONE_HIGHMEM. From the book of "Undstand the Linux
> > kernel ", the ZONE_DMA has the effect that the Direct Memory Access
> > (DMA) processors for old ISA buses have a strong limitation: they are
> > able to address only the first 16 MB of RAM. SO ,we must set a zone
> > for  the DMA on ISA bus.  And I suspect that the hardware has
> > developed so quickly .And  in this days the ISA has been weeded out.
> > And so ,if we not defined the ZONE_DMA, is the system be effected? And
> > why not remove ZONE_DMA from the kernel . If it cann‘t to do so，the
> > compatibility is the only reason?
>
> While ISA is gone as a true peripheral interconnect for new systems it
> does,
> actually, still live on in a lot of systems that Linux still supports.
> While
> those systems, generally, are running the same kernel and userspace they
> were
> a decade ago I have no doubt that somebody might find an old machine and
> put
> Linux on it - just because they could.
>
> And that also discounts the non-IBM PC machines that are out there that
> Linux
> also supports. While I don't know enough about them to say for sure, I am
> quite certain that at least some of them are still using the ISA bus.
>
> DRH
>



-- 
Laboratory of Service Computing Technology and System

p-web:http://tek-life.org/blog
QQ:150439216



-- 
Laboratory of Service Computing Technology and System

p-web:http://tek-life.org/blog
QQ:150439216
