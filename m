Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab0HJPiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:38:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54710 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab0HJPio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:38:44 -0400
Date: Tue, 10 Aug 2010 08:37:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, axboe@kernel.dk,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 6 (block git tree)
Message-Id: <20100810083737.c761fc8f.randy.dunlap@oracle.com>
In-Reply-To: <4C5C5D18.6050905@oracle.com>
References: <20100806132758.6001d416.sfr@canb.auug.org.au>
	<20100806120456.5eca82b7.randy.dunlap@oracle.com>
	<4C5C5D18.6050905@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Aug 2010 12:06:00 -0700 Randy Dunlap wrote:

> On 08/06/10 12:04, Randy Dunlap wrote:
> > On Fri, 6 Aug 2010 13:27:58 +1000 Stephen Rothwell wrote:
> > 
> >> Hi all,
> >>
> >> As the merge window is open, please do not add 2.6.37 material to your
> >> linux-next included trees until after 2.6.36-rc1.
> >>
> >> Changes since 20100805:
> >>
> >> The block tree lost its build failure and a conflict.
> > 
> > 
> > Lots of source files now need <linux/blk_types.h>:
> > 
> > mm/filemap.c:2164: error: 'REQ_WRITE' undeclared
> > fs/read_write.c:362: error: 'REQ_WRITE' undeclared
> > fs/splice.c:1108: error: 'REQ_WRITE' undeclared
> > fs/aio.c:1496: error: 'REQ_WRITE' undeclared
> > drivers/memstick/core/memstick.c:272: error: 'REQ_WRITE' undeclared
> > drivers/memstick/host/tifm_ms.c:218: error: 'REQ_WRITE' undeclared
> > drivers/memstick/host/jmb38x_ms.c:333: error: 'REQ_WRITE' undeclared
> > drivers/staging/spectra/ffsport.c:277: error: 'REQ_TYPE_LINUX_BLOCK' undeclared
> > fs/compat.c:1274: error: 'REQ_WRITE' undeclared
> 
> 
> Sorry, I see that this has already been fixed.

s/fixed/addressed/  but not yet merged into linux-next.
Can we get that fixed, please?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
