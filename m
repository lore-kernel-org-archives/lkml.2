Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab1J2Nty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 09:49:54 -0400
Received: from mail001.aei.ca ([206.123.6.130]:48239 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721Ab1J2Ntx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 09:49:53 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Oct 2011 09:49:53 EDT
From: Ed Tomlinson <edt@aei.ca>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Date: Sat, 29 Oct 2011 09:43:08 -0400
Message-ID: <1777884.rjTZT9Wj01@grover>
Organization: me
User-Agent: KMail/4.7.2 (Linux/3.1.0-crc+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 October 2011 11:52:22 Dan Magenheimer wrote:
> Hi Linus --

> SO... Please pull:
> 
> git://oss.oracle.com/git/djm/tmem.git #tmem
> 

My wife has an old PC thats short on memory.  Its got Ubuntu
running on it.  It also has cleancache and zram enabled.  The
box works better when using these.  Frontcache would improve 
things further.  It will balance the tmem vs physical memory
dynamicily making it a better solution than zram.

I'd love to see this in the kernel.

Thanks
Ed Tomlinson

PS.  At work we use AIX with memory compression.  With the
workloads we run compression lets the OS act like it has 30%
more memory.  It works.  It would be nice to have a similar
facility in Linux.
