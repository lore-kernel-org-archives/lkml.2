Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1AMTg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:36:29 -0500
Received: from canuck.infradead.org ([134.117.69.58]:32818 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1AMTg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:36:26 -0500
Subject: Re: [PATCH 01/35] writeback: enabling gate limit for light dirtied
 bdi
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110113034401.GB7840@localhost>
References: <20101213144646.341970461@intel.com>
	 <20101213150326.480108782@intel.com> <20110112214303.GC14260@quack.suse.cz>
	 <20110113034401.GB7840@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 Jan 2011 20:26:10 +0100
Message-ID: <1294946770.30950.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 11:44 +0800, Wu Fengguang wrote:
> When testing 10-disk JBOD setup, I
> find that bdi_dirty_limit fluctuations too much. So I'm considering
> use global_dirty_limit as control target. 

Is this because the bandwidth is equal or larger than the dirty period?


