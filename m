Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2BVQQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:16:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2BVQQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:16:20 -0500
Date: Wed, 22 Feb 2012 14:14:41 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, Randy Dunlap <rdunlap@xenotime.net>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
Message-ID: <20120222161440.GB1986@x61.redhat.com>
References: <20120222115320.GA3107@x61.redhat.com>
 <alpine.DEB.2.00.1202220754140.21637@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202220754140.21637@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 07:55:16AM -0600, Christoph Lameter wrote:
> 
> Please use node_nr_objects() instead of directly accessing total_objects.
> total_objects are only available if debugging support was compiled in.
> 
Shame on me! I've wrongly assumed that it would be safe accessing
the element because SLUB_DEBUG is turned on by default when slub is chosen.

Considering your note on my previous mistake, shall I assume now that it
would be better having this whole dump feature dependable on CONFIG_SLUB_DEBUG,
instead of just CONFIG_SLUB ?

Thanks for your feedback!
-- 
Rafael Aquini <aquini@redhat.com>
Software Maintenance Engineer
Red Hat, Inc.
+55 51 4063.9436 / 8426138 (ext)
