Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab2F2UXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:23:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48644 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2F2UXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:23:37 -0400
Date: Fri, 29 Jun 2012 13:23:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: CONFIG_HAVE_MEMBLOCK_NODE ->
 CONFIG_HAVE_MEMBLOCK_NODE_MAP
Message-ID: <20120629202333.GE21048@google.com>
References: <1341000877-12068-1-git-send-email-rabin@rab.in>
 <20120629132157.0f543593.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629132157.0f543593.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 01:21:57PM -0700, Andrew Morton wrote:
> >  static inline int zone_movable_is_highmem(void)
> >  {
> > -#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
> > +#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
> >  	return movable_zone == ZONE_HIGHMEM;
> >  #else
> >  	return 0;
> 
> Huh.  I wonder why nobody noticed.

Well, the combination is 32bit + memory hotplug....

-- 
tejun
