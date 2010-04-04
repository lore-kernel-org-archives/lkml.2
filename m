Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab0DDFQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 01:16:35 -0400
Received: from keil-draco.com ([216.193.185.50]:46842 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750720Ab0DDFQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 01:16:29 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Apr 2010 01:16:29 EDT
From: Daniel Hazelton <dhazelton@enter.net>
To: "tek-life" <teklife.kernel@gmail.com>
Subject: Re: Can we remove the Zone_DMA?
Date: Sun, 4 Apr 2010 01:07:13 -0400
User-Agent: KMail/1.13.1 (Linux/2.6.31-sabayon; KDE/4.4.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
In-Reply-To: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004040107.15783.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 April 2010 12:21:54 am tek-life wrote:
> I¡¯m a newbie on the linux kernel. Now I am reading the source code of
> Linux . I have a question in the following about ZONE_DMA.
> 
> 
> In Linux , The Memory is divided to three zone. They are ZONE_DMA
> ¡¢ZONE_NORMAL  and ZONE_HIGHMEM. From the book of "Undstand the Linux
> kernel ", the ZONE_DMA has the effect that the Direct Memory Access
> (DMA) processors for old ISA buses have a strong limitation: they are
> able to address only the first 16 MB of RAM. SO ,we must set a zone
> for  the DMA on ISA bus.  And I suspect that the hardware has
> developed so quickly .And  in this days the ISA has been weeded out.
> And so ,if we not defined the ZONE_DMA, is the system be effected? And
> why not remove ZONE_DMA from the kernel . If it cann¡®t to do so£¬the
> compatibility is the only reason?

While ISA is gone as a true peripheral interconnect for new systems it does, 
actually, still live on in a lot of systems that Linux still supports. While 
those systems, generally, are running the same kernel and userspace they were 
a decade ago I have no doubt that somebody might find an old machine and put 
Linux on it - just because they could.

And that also discounts the non-IBM PC machines that are out there that Linux 
also supports. While I don't know enough about them to say for sure, I am 
quite certain that at least some of them are still using the ISA bus.

DRH
