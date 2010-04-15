Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0DOPuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:50:39 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59487 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0DOPui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:50:38 -0400
Date: Thu, 15 Apr 2010 08:48:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: update documentation v8
Message-Id: <20100415084838.afe18a68.randy.dunlap@oracle.com>
In-Reply-To: <20100415093406.d7331ae2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100408145800.ca90ad81.kamezawa.hiroyu@jp.fujitsu.com>
	<20100409134553.58096f80.kamezawa.hiroyu@jp.fujitsu.com>
	<20100409100430.7409c7c4.randy.dunlap@oracle.com>
	<20100413134553.7e2c4d3d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100413060405.GF3994@balbir.in.ibm.com>
	<20100413152048.55408738.kamezawa.hiroyu@jp.fujitsu.com>
	<20100413064855.GH3994@balbir.in.ibm.com>
	<20100413155841.ca6bc425.kamezawa.hiroyu@jp.fujitsu.com>
	<4BC493B4.2040709@oracle.com>
	<20100414102221.2c540a0d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414111146.c2907cd7.randy.dunlap@oracle.com>
	<20100415093406.d7331ae2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BC735BB.007F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 09:34:06 +0900 KAMEZAWA Hiroyuki wrote:

> On Wed, 14 Apr 2010 11:11:46 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > >  	#echo 1 > memory.oom_control
> > 
> > 
> > BTW:  it would be a lot easier [for reviewing] if you could freeze (or merge) this version
> > and then apply fixes on top of it with a different (and shorter) patch.
> > 
> > Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> Thank you very much for your patient review. It has been very helpful.
> 
> Here is fixed one.

Please ship it!

Thanks.

---
~Randy
