Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1GAAWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:22:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57700 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1GAAWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:22:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 1 Jul 2011 09:15:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-06-30-15-59 uploaded (mm/memcontrol.c)
Message-Id: <20110701091525.bd8095f1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110630172054.49287627.randy.dunlap@oracle.com>
References: <201106302259.p5UMxh5i019162@imap1.linux-foundation.org>
	<20110630172054.49287627.randy.dunlap@oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 17:20:54 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 30 Jun 2011 15:59:43 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-06-30-15-59 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> >    git://zen-kernel.org/kernel/mmotm.git
> > or
> >    git://git.cmpxchg.org/linux-mmotm.git
> > 
> > It contains the following patches against 3.0-rc5:
> 
> I see several of these build errors:
> 
> mmotm-2011-0630-1559/mm/memcontrol.c:1579: error: implicit declaration of function 'mem_cgroup_node_nr_file_lru_pages'
> mmotm-2011-0630-1559/mm/memcontrol.c:1583: error: implicit declaration of function 'mem_cgroup_node_nr_anon_lru_pages'
> 

Thanks...maybe !CONFIG_NUMA again. will post a fix soon.

Thanks,
-Kame


