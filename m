Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab0DRLEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 07:04:55 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:58795 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756630Ab0DRLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 07:04:53 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o3IB4UIA032330
Subject: Re: Can we remove the Zone_DMA?
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: tek-life <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com
In-Reply-To: <201004040107.15783.dhazelton@enter.net>
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
	 <201004040107.15783.dhazelton@enter.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Apr 2010 13:04:30 +0200
Message-ID: <1271588670.1389.5.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Son, 2010-04-04 at 01:07 -0400, Daniel Hazelton wrote:
> On Sunday 04 April 2010 12:21:54 am tek-life wrote:
> > I’m a newbie on the linux kernel. Now I am reading the source code of
> > Linux . I have a question in the following about ZONE_DMA. 
> > 
> > In Linux , The Memory is divided to three zone. They are ZONE_DMA
> > 、ZONE_NORMAL  and ZONE_HIGHMEM. From the book of "Undstand the Linux
> > kernel ", the ZONE_DMA has the effect that the Direct Memory Access
> > (DMA) processors for old ISA buses have a strong limitation: they are
> > able to address only the first 16 MB of RAM. SO ,we must set a zone
> > for  the DMA on ISA bus.  And I suspect that the hardware has
> > developed so quickly .And  in this days the ISA has been weeded out.

That doesn't imply that the "old" systems and hardware vanishes (even
not quickly).

> > And so ,if we not defined the ZONE_DMA, is the system be effected? And
> > why not remove ZONE_DMA from the kernel . If it cann‘t to do so，the
> > compatibility is the only reason?
> 
> While ISA is gone as a true peripheral interconnect for new systems it does, 
> actually, still live on in a lot of systems that Linux still supports. While 
> those systems, generally, are running the same kernel and userspace they were 
> a decade ago I have no doubt that somebody might find an old machine and put 
> Linux on it - just because they could.
> 
> And that also discounts the non-IBM PC machines that are out there that Linux 
> also supports. While I don't know enough about them to say for sure, I am 
> quite certain that at least some of them are still using the ISA bus.

PC-104 has an ISA bus. And it is far from dead and currently deployed
for new systems.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

