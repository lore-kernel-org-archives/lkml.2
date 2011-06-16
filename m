Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab1FPQ0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:26:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54262 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab1FPQ01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:26:27 -0400
Subject: Re: mmotm 2011-06-15-16-56 uploaded (mm/page_cgroup.c)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20110616103559.GA5244@suse.de>
References: <201106160034.p5G0Y4dr028904@imap1.linux-foundation.org>
	 <20110615214917.a7dce8e6.randy.dunlap@oracle.com>
	 <20110616172819.1e2d325c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20110616103559.GA5244@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 09:25:42 -0700
Message-ID: <1308241542.11430.119.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 11:35 +0100, Mel Gorman wrote:
> > This patch removes definitions of node_start/end_pfn() in each archs
> > and defines a unified one in linux/mmzone.h. It's not under
> > CONFIG_NEED_MULTIPLE_NODES, now.
> 
> Does anyone remember *why* this did not happen in the first place? I
> can't think of a good reason so I've cc'd Dave Hansen as he might
> remember. 

You mean why it's not under CONFIG_NEED_MULTIPLE_NODES?  I'd guess it's
just because it keeps working in all configurations since the
pg_data_t->node_*_pfn entries are defined everywhere.

Is that what you're asking?

-- Dave

