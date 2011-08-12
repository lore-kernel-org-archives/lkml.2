Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1HLJsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 05:48:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39015 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1HLJsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 05:48:39 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Aug 2011 11:47:54 +0200
In-Reply-To: <20110812024353.GA11606@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com> <1312811193.10488.33.camel@twins>
	 <20110808141128.GA22080@localhost> <1312814501.10488.41.camel@twins>
	 <20110808230535.GC7176@localhost> <1313103367.26866.39.camel@twins>
	 <20110812024353.GA11606@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313142474.6576.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 10:43 +0800, Wu Fengguang wrote:
> >                s - x 3
> >  f(x) :=  1 + (-----)
> >                l - s
> 

> Looks very neat, much simpler than the three curves solution!

Glad you like it, there is of course the small matter of real-world
behaviour to consider, lets hope that works as well :-)
