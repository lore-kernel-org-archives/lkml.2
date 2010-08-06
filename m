Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521Ab0HFTJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:09:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22632 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965416Ab0HFTJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:09:03 -0400
Date: Fri, 6 Aug 2010 12:04:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, axboe@kernel.dk
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 6 (block git tree)
Message-Id: <20100806120456.5eca82b7.randy.dunlap@oracle.com>
In-Reply-To: <20100806132758.6001d416.sfr@canb.auug.org.au>
References: <20100806132758.6001d416.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010 13:27:58 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> As the merge window is open, please do not add 2.6.37 material to your
> linux-next included trees until after 2.6.36-rc1.
> 
> Changes since 20100805:
> 
> The block tree lost its build failure and a conflict.


Lots of source files now need <linux/blk_types.h>:

mm/filemap.c:2164: error: 'REQ_WRITE' undeclared
fs/read_write.c:362: error: 'REQ_WRITE' undeclared
fs/splice.c:1108: error: 'REQ_WRITE' undeclared
fs/aio.c:1496: error: 'REQ_WRITE' undeclared
drivers/memstick/core/memstick.c:272: error: 'REQ_WRITE' undeclared
drivers/memstick/host/tifm_ms.c:218: error: 'REQ_WRITE' undeclared
drivers/memstick/host/jmb38x_ms.c:333: error: 'REQ_WRITE' undeclared
drivers/staging/spectra/ffsport.c:277: error: 'REQ_TYPE_LINUX_BLOCK' undeclared
fs/compat.c:1274: error: 'REQ_WRITE' undeclared


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
