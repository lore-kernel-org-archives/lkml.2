Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0DMN5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 09:57:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0DMN5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:57:35 -0400
Date: Tue, 13 Apr 2010 09:57:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <amezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: update documentation v5
Message-ID: <20100413135718.GA4493@redhat.com>
References: <20100408145800.ca90ad81.kamezawa.hiroyu@jp.fujitsu.com> <20100409134553.58096f80.kamezawa.hiroyu@jp.fujitsu.com> <20100409100430.7409c7c4.randy.dunlap@oracle.com> <20100413134553.7e2c4d3d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413134553.7e2c4d3d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 01:45:53PM +0900, KAMEZAWA Hiroyuki wrote:

[..]
> -2. Locking
> +2.6 Locking
>  
> -The memory controller uses the following hierarchy
> +   lock_page_cgroup()/unlock_page_cgroup() should not be called under
> +   mapping->tree_lock.
>  

Because I never understood very well, I will ask. Why lock_page_cgroup()
should not be called under mapping->tree_lock?

Thanks
Vivek
