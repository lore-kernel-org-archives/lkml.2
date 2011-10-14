Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1JNSWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:22:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60678 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1JNSWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:22:04 -0400
Message-ID: <4E987DC7.3000903@linux.vnet.ibm.com>
Date: Fri, 14 Oct 2011 13:21:59 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: gregkh@suse.de, cascardo@holoscopio.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, rcj@linux.vnet.ibm.com, brking@linux.vnet.ibm.com
Subject: Re: [PATCH] staging: zcache: remove zcache_direct_reclaim_lock
References: <1318448460-5930-1-git-send-email-sjenning@linux.vnet.ibm.com> <3e84809b-a45d-4980-b342-c2d671f87f79@default> <4E986B85.6020006@linux.vnet.ibm.com>
In-Reply-To: <4E986B85.6020006@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 12:04 PM, Seth Jennings wrote:
> On 10/12/2011 03:39 PM, Dan Magenheimer wrote:
>>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>>> Subject: [PATCH] staging: zcache: remove zcache_direct_reclaim_lock
> 
> If the preload is called with PF_MEMALLOC set, then 
> the shrinker will not be run during a kmem_cache_alloc().
> 
> However if the preload is called with PF_MEMALLOC being set
Sorry, should have been *without PF_MEMALLOC being set
