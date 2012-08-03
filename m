Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2HCLN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 07:13:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2HCLN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 07:13:58 -0400
Date: Fri, 3 Aug 2012 08:13:09 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rafael Aquini <aquini@linux.com>
Subject: Re: [PATCH v4 1/3] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120803111309.GA1848@t510.redhat.com>
References: <cover.1342485774.git.aquini@redhat.com>
 <49f828a9331c9b729fcf77226006921ec5bc52fa.1342485774.git.aquini@redhat.com>
 <20120718054824.GA32341@bbox>
 <20120720194858.GA16249@t510.redhat.com>
 <20120723023332.GA6832@bbox>
 <20120723181952.GA27373@t510.redhat.com>
 <5019975B.6010708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5019975B.6010708@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 04:53:47PM -0400, Rik van Riel wrote:
> On 07/23/2012 02:19 PM, Rafael Aquini wrote:
> 
> >In a glance, I believe this whole dance you're suggesting might just be too much
> >of an overcomplication, and the best approach would be simply teaching the
> >hotplug bits about the ballooned corner case just like it's being done to
> >compaction/migration. However, I'll look at it carefully before making any other
> >adjustments/propositions over here.
> 
> Compaction and hotplug do essentially the same thing
> here: "collect all the movable pages from a page block,
> and move them elsewhere".
> 
> Whether or not it is easier for them to share code, or
> to duplicate a few lines of code, is something that can
> be looked into later.

I'm 100% in agreement with your thoughts here.

