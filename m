Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0LMMjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:39:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:43600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0LMMji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:39:38 -0500
Subject: Re: [PATCH 00/47] IO-less dirty throttling v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101213114911.GA2232@localhost>
References: <20101213064249.648862451@intel.com>
	 <1292239631.6803.186.camel@twins>  <20101213114911.GA2232@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 13:38:14 +0100
Message-ID: <1292243894.6803.201.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 19:49 +0800, Wu Fengguang wrote:
> > Reviewing is lots easier if the patches present logical steps. The
> > presented series will have us looking back and forth, review patch, find
> > bugs, then scan fwd to see if the bug has been solved, etc..
> 
> Good suggestion. Sorry I did have the plan to fold them at some later
> time.  I'll do a new version to fold the patches 16-25.  26-31 will be
> retained since they are logical enhancements that do not involve
> back-and-forth changes. 12 will be removed as it seems not absolutely
> necessary -- let the users do whatever they feel OK, even if it means
> make the throttling algorithms work in some suboptimal condition.
> 

Thanks, much appreciated! I'll await this new series.
