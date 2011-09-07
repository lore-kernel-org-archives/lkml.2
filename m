Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1IGQd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:33:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:38293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab1IGQdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:24 -0400
Subject: Re: [PATCH 05/18] writeback: per task dirty rate limit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 07 Sep 2011 09:31:56 +0200
In-Reply-To: <20110907010448.GA6513@localhost>
References: <20110904015305.367445271@intel.com>
	 <20110904020915.240747479@intel.com> <1315324030.14232.14.camel@twins>
	 <20110907010448.GA6513@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315380716.11101.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 09:04 +0800, Wu Fengguang wrote:

> So the sqrt naturally leads to less overheads and more N tolerance for
> large memory servers, which have large (thresh-freerun) gaps.

Thanks, and as you say its an initial guess, later refined using patch
14.
