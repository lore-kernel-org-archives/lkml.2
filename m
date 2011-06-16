Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1FPFzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 01:55:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60027 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1FPFzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 01:55:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jun 2011 14:48:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-06-15-16-56 uploaded (mm/page_cgroup.c)
Message-Id: <20110616144848.e99c84d0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110615214917.a7dce8e6.randy.dunlap@oracle.com>
References: <201106160034.p5G0Y4dr028904@imap1.linux-foundation.org>
	<20110615214917.a7dce8e6.randy.dunlap@oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 21:49:17 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 15 Jun 2011 16:56:49 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-06-15-16-56 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> >    git://zen-kernel.org/kernel/mmotm.git
> > or
> >    git://git.cmpxchg.org/linux-mmotm.git
> > 
> > It contains the following patches against 3.0-rc3:
> 
> 
> (x86_64 build:)
> 
> mm/page_cgroup.c: In function 'page_cgroup_init':
> mm/page_cgroup.c:308: error: implicit declaration of function 'node_start_pfn'
> mm/page_cgroup.c:309: error: implicit declaration of function 'node_end_pfn'
> 
> 
> full kernel .config file is attached.
> 
Thank you. I'll dig today.

-Kame

