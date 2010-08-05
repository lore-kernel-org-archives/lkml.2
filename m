Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670Ab0HEO4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:56:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49746 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760627Ab0HEO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iGkLNSOo5WpqrTQdQBbnFp5lvtF8oUZVUUhLERkw00S9620+PP2oul+SF2kpIuVHy2
         fyMuQUvLPuPhXAglBuceOCVyZYyQn4pOofuaINu0Ml7Awaj1CgQG2/fO7VhJ3ZBNddES
         wkXTwpMyttD/zcQfj6LdK5VP2HFKg6Of5XCR0=
Date: Thu, 5 Aug 2010 23:56:06 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 3/6] writeback: kill writeback_control.more_io
Message-ID: <20100805145606.GA3083@barrios-desktop>
References: <20100722050928.653312535@intel.com>
 <20100722061822.763629019@intel.com>
 <20100801153424.GA8204@barrios-desktop>
 <20100805145053.GA6161@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805145053.GA6161@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:50:53PM +0800, Wu Fengguang wrote:
> > include/trace/events/ext4.h also have more_io field. 
> 
> I didn't find it in linux-next. What's your kernel version?

I used mmotm-07-29. 

> 
> Thanks,
> Fengguang

-- 
Kind regards,
Minchan Kim
