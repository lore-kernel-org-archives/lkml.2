Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0FRWkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:40:41 -0400
Received: from xenotime.net ([72.52.115.56]:52650 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753589Ab0FRWkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:40:39 -0400
Date: Fri, 18 Jun 2010 15:40:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Kulikov Vasiliy <segooon@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation/sysctl/vm.txt typo
Message-Id: <20100618154033.1e949749.rdunlap@xenotime.net>
In-Reply-To: <20100618142252.GA31086@elliptictech.com>
References: <1276859270.3159.5.camel@shinshilla>
	<20100618142252.GA31086@elliptictech.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 10:22:52 -0400 Nick Bowler wrote:

> On 15:07 Fri 18 Jun     , Kulikov Vasiliy wrote:
> > --- a/Documentation/sysctl/vm.txt
> > +++ b/Documentation/sysctl/vm.txt
> > @@ -196,7 +196,7 @@ controlled by this knob are discussed in
> > Documentation/laptops/laptop-mode.txt.
> >  
> >  legacy_va_layout
> >  
> > -If non-zero, this sysctl disables the new 32-bit mmap mmap layout - the
> > kernel
> > +If non-zero, this sysctl disables the new 32-bit mmap layout - the
> > kernel
> >  will use the legacy (2.4) layout for all processes.
> 
> You might want to check your mailer settings: this patch has been
> mangled.

Yep.

There are some mail client clues in Documentation/email-clients.txt.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
