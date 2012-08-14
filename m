Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2HNUDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:03:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab2HNUDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:03:44 -0400
Date: Tue, 14 Aug 2012 17:03:27 -0300
From: Rafael Aquini <aquini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120814200326.GC22133@t510.redhat.com>
References: <cover.1344619987.git.aquini@redhat.com>
 <292b1b52e863a05b299f94bda69a61371011ac19.1344619987.git.aquini@redhat.com>
 <20120813082619.GE14081@redhat.com>
 <20120814174404.GA13338@t510.redhat.com>
 <20120814193525.GB28840@redhat.com>
 <20120814194837.GA28863@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814194837.GA28863@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:48:37PM +0300, Michael S. Tsirkin wrote:
> > 
> > E.g. kvm can emulate hyperv so it could in theory have hyperv balloon.
> > This is mm stuff it is best not to tie it to specific drivers.
> 
> But of course I agree this is not top priority, no need
> to block submission on this, just nice to have.
>
This surely is interesting to look at, in the near future. 
