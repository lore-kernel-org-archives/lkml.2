Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0DSNo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:44:57 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44163 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943Ab0DSNo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:44:56 -0400
Date: Mon, 19 Apr 2010 09:44:55 -0400
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Daniel Hazelton <dhazelton@enter.net>, tek-life <teklife.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Can we remove the Zone_DMA?
Message-ID: <20100419134455.GC32023@caffeine.csclub.uwaterloo.ca>
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com> <201004040107.15783.dhazelton@enter.net> <1271588670.1389.5.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271588670.1389.5.camel@thorin>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 18, 2010 at 01:04:30PM +0200, Bernd Petrovitsch wrote:
> On Son, 2010-04-04 at 01:07 -0400, Daniel Hazelton wrote:
> > On Sunday 04 April 2010 12:21:54 am tek-life wrote:
> > > I’m a newbie on the linux kernel. Now I am reading the source code of
> > > Linux . I have a question in the following about ZONE_DMA. 
> > > 
> > > In Linux , The Memory is divided to three zone. They are ZONE_DMA
> > > 、ZONE_NORMAL  and ZONE_HIGHMEM. From the book of "Undstand the Linux
> > > kernel ", the ZONE_DMA has the effect that the Direct Memory Access
> > > (DMA) processors for old ISA buses have a strong limitation: they are
> > > able to address only the first 16 MB of RAM. SO ,we must set a zone
> > > for  the DMA on ISA bus.  And I suspect that the hardware has
> > > developed so quickly .And  in this days the ISA has been weeded out.
> 
> That doesn't imply that the "old" systems and hardware vanishes (even
> not quickly).

I have a 486 still running just fine with ISA (and VLB) only.  Also LPC
is in fact ISA and is found in almost all modern PCs.  Some even still
have parallel ports which I believe can do DMA, and they certainly could
still have a 16MB limit on them.

> > > And so ,if we not defined the ZONE_DMA, is the system be effected? And
> > > why not remove ZONE_DMA from the kernel . If it cann‘t to do so，the
> > > compatibility is the only reason?
> > 
> > While ISA is gone as a true peripheral interconnect for new systems it does, 
> > actually, still live on in a lot of systems that Linux still supports. While 
> > those systems, generally, are running the same kernel and userspace they were 
> > a decade ago I have no doubt that somebody might find an old machine and put 
> > Linux on it - just because they could.
> > 
> > And that also discounts the non-IBM PC machines that are out there that Linux 
> > also supports. While I don't know enough about them to say for sure, I am 
> > quite certain that at least some of them are still using the ISA bus.
> 
> PC-104 has an ISA bus. And it is far from dead and currently deployed
> for new systems.

Yeah that's still around too.

-- 
Len Sorensen
