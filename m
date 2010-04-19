Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0DSPPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:15:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59795 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0DSPPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:15:31 -0400
Date: Mon, 19 Apr 2010 16:15:12 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100419151511.GV19264@csn.ul.ie>
References: <20100413202021.GZ13327@think> <20100414014041.GD2493@dastard> <20100414155233.D153.A69D9226@jp.fujitsu.com> <20100414072830.GK2493@dastard> <20100414085132.GJ25756@csn.ul.ie> <20100415013436.GO2493@dastard> <20100415102837.GB10966@csn.ul.ie> <20100415134217.GB3794@think> <20100416150510.GL19264@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100416150510.GL19264@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 04:05:10PM +0100, Mel Gorman wrote:
> > vi fs/direct-reclaim-helper.c, it has a few placeholders for where the
> > real code needs to go....just look for the ~ marks.
> > 
> 
> I must be blind. What tree is this in? I can't see it v2.6.34-rc4,
> mmotm or google.
> 

Bah, Johannes corrected my literal mind. har de har har :)

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
