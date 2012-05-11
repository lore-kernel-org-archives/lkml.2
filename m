Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab2EKTfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:35:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28174 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab2EKTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:35:28 -0400
Date: Fri, 11 May 2012 15:29:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
Message-ID: <20120511192915.GD3785@phenom.dumpdata.com>
References: <4FABD503.4030808@vflare.org>
 <4FABDA9F.1000105@linux.vnet.ibm.com>
 <20120510151941.GA18302@kroah.com>
 <4FABECF5.8040602@vflare.org>
 <20120510164418.GC13964@kroah.com>
 <4FABF9D4.8080303@vflare.org>
 <20120510173322.GA30481@phenom.dumpdata.com>
 <4FAC4E3B.3030909@kernel.org>
 <8473859b-42f3-4354-b5ba-fd5b8cbac22f@default>
 <4FAC59F6.4080503@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAC59F6.4080503@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > there are other users that require a different interface
> > or a more precise abstract API, zsmalloc could then
> > evolve to meet the needs of multiple users.  But I think
> 
> 
> At least, zram is also primary user and it also has such mess although it's not severe than zcache. zram->table[index].handle sometime has real (void*) handle, sometime (struct page*).

Yikes. Yeah that needs to be fixed.
