Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1FPQvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:51:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab1FPQvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:51:52 -0400
Date: Thu, 16 Jun 2011 17:51:46 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-06-15-16-56 uploaded (mm/page_cgroup.c)
Message-ID: <20110616165146.GB5244@suse.de>
References: <201106160034.p5G0Y4dr028904@imap1.linux-foundation.org>
 <20110615214917.a7dce8e6.randy.dunlap@oracle.com>
 <20110616172819.1e2d325c.kamezawa.hiroyu@jp.fujitsu.com>
 <20110616103559.GA5244@suse.de>
 <1308241542.11430.119.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1308241542.11430.119.camel@nimitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:25:42AM -0700, Dave Hansen wrote:
> On Thu, 2011-06-16 at 11:35 +0100, Mel Gorman wrote:
> > > This patch removes definitions of node_start/end_pfn() in each archs
> > > and defines a unified one in linux/mmzone.h. It's not under
> > > CONFIG_NEED_MULTIPLE_NODES, now.
> > 
> > Does anyone remember *why* this did not happen in the first place? I
> > can't think of a good reason so I've cc'd Dave Hansen as he might
> > remember. 
> 
> You mean why it's not under CONFIG_NEED_MULTIPLE_NODES?  I'd guess it's
> just because it keeps working in all configurations since the
> pg_data_t->node_*_pfn entries are defined everywhere.
> 
> Is that what you're asking?
> 

No, why was node_start_pfn() and node_end_pfn() defined optionally
on a per-architecture basis?

-- 
Mel Gorman
SUSE Labs
