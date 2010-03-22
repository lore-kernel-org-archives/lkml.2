Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0CVMZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:25:06 -0400
Received: from lo.gmane.org ([80.91.229.12]:37394 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab0CVMZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:25:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: better/faster kernel tarball compression
Date: Mon, 22 Mar 2010 12:00:51 +0000
Message-ID: <jo2k77-9sp.ln1@chipmunk.wormnet.eu>
References: <4BA741D7.9020008@wpkg.org>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>
>> 403804160 linux-2.6.34-rc2.tar
>>   67479563 linux-2.6.34-rc2.tar.bz2
>>   58452531 linux-2.6.34-rc2.tar.lz
> 
> Speaking of file sizes, xz[1] already provides better compression:
> 
> xz -k -9 linux-2.6.34-rc2.tar
> 
>     55320408 linux-2.6.34-rc2.tar.xz
> 
> xz -e -k -9 linux-2.6.34-rc2.tar
> 
>     54800808 linux-2.6.34-rc2.tar.xz
> 
> One drawback of xz is that it's not multi-threaded, much like bzip2 or 
> gzip; would be great if it could be changed.
> 
For some time there has been a multi-threaded bzip2 called 
pbzip2[1], for some time; hell even Debian has it :)

I have no idea why the original poster is trying to say how "all teh 
awesome" his code is being faster, well 'duh' it is using all the cores 
on $BOX rather than just a single one.

I would be interested in comparisons against pbzip2 and the amusingly 
named pigz[2]...plus a bunch of memory use comparisons, my AR7 board 
only has 16MB of RAM :)

Cheers

[1] http://compression.ca/pbzip2/ - supports stdio (de)compression
[2] http://www.zlib.net/pigz/ - no idea if this supports stdio

-- 
Alexander Clouter
.sigmonster says: Approved for veterans.

