Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1HYPTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:19:00 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:55610 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753923Ab1HYPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:18:51 -0400
Date: Thu, 25 Aug 2011 08:18:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2011-08-24-14-08 uploaded
Message-Id: <20110825081848.f6e8a62d.rdunlap@xenotime.net>
In-Reply-To: <20110825161307.7c921e46.kamezawa.hiroyu@jp.fujitsu.com>
References: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
	<20110825161307.7c921e46.kamezawa.hiroyu@jp.fujitsu.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 16:13:07 +0900 KAMEZAWA Hiroyuki wrote:

> On Wed, 24 Aug 2011 14:09:05 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-08-24-14-08 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 3.1-rc3:
> > (patches marked "*" will be included in linux-next)
> > 
> 
> just reporting.
> 
> A compile error from linux-next.patch.
> 
> drivers/built-in.o: In function `dwc3_testmode_open':
> /home/kamezawa/Kernel/mmotm-Aug24/drivers/usb/dwc3/debugfs.c:481: undefined reference to `dwc3_send_gadget_ep_cmd'
> /home/kamezawa/Kernel/mmotm-Aug24/drivers/usb/dwc3/debugfs.c:482: undefined reference to `dwc3_send_gadget_ep_cmd'
> make: *** [.tmp_vmlinux1] Error 

Yes, I've sent GregKH a patch for this against linux-next.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
