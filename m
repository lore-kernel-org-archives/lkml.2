Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1HSOOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:14:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1HSOOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:14:21 -0400
Date: Fri, 19 Aug 2011 10:14:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 10/11] VFS: Cache request_queue in struct block_device
Message-ID: <20110819141409.GD18656@redhat.com>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
 <1312259893-4548-11-git-send-email-andi@firstfloor.org>
 <20110818194245.GJ15413@redhat.com>
 <4E4D7E3C.8060104@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4D7E3C.8060104@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 02:03:56PM -0700, Andi Kleen wrote:
> 
> >Is the performance gain because of this one less dereference really
> >substantial.
> Yes it is measurable on a large macro benchmark.
> 
> The gain is from doing the prefetch early enough, and that needs the
> additional pointer.

So it gives you extra .3% (as mentioned in your first mail). IMHO, for
.3% we should not cache extra request queue pointer.

Thanks
Vivek
