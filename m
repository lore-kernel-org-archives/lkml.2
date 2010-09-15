Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0IORmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:42:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43086 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab0IORmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:42:05 -0400
Date: Wed, 15 Sep 2010 23:11:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Richard Guenther <rguenther@suse.de>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] After swapout/swapin private dirty mappings are
 reported clean in smaps
Message-ID: <20100915174157.GA22371@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100915134724.C9EE.A69D9226@jp.fujitsu.com>
 <201009151034.22497.knikanth@suse.de>
 <20100915141710.C9F7.A69D9226@jp.fujitsu.com>
 <201009151201.11359.knikanth@suse.de>
 <20100915140911.GC4383@balbir.in.ibm.com>
 <alpine.LNX.2.00.1009151612450.28912@zhemvz.fhfr.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009151612450.28912@zhemvz.fhfr.qr>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Richard Guenther <rguenther@suse.de> [2010-09-15 16:14:17]:

> On Wed, 15 Sep 2010, Balbir Singh wrote:
> 
> > * Nikanth Karthikesan <knikanth@suse.de> [2010-09-15 12:01:11]:
> > 
> > > How? Current smaps information without this patch provides incorrect 
> > > information. Just because a private dirty page became part of swap cache, it 
> > > shown as clean and backed by a file. If it is shown as clean and backed by 
> > > swap then it is fine.
> > >
> > 
> > How is GDB using this information?  
> 
> GDB counts the number of dirty and swapped pages in a private mapping and
> based on that decides whether it needs to dump it to a core file or not.
> If there are no dirty or swapped pages gdb assumes it can reconstruct
> the mapping from the original backing file.  This way for example
> shared libraries do not end up in the core file.
>

Thanks for clarifying 

-- 
	Three Cheers,
	Balbir
