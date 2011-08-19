Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1HSQXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:23:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54981 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab1HSQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:23:13 -0400
Date: Fri, 19 Aug 2011 18:23:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 10/11] VFS: Cache request_queue in struct block_device
Message-ID: <20110819162312.GE25996@one.firstfloor.org>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org> <1312259893-4548-11-git-send-email-andi@firstfloor.org> <20110818194245.GJ15413@redhat.com> <4E4D7E3C.8060104@linux.intel.com> <20110819141409.GD18656@redhat.com> <20110819153622.GD25996@one.firstfloor.org> <20110819155534.GA13464@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819155534.GA13464@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Primarily because of code complexity. We are stashing away a pointer and
> not taking any reference anywhere. So I am not even sure who is making
> sure that request queue is not gone and there are no comments in the code
> about why we are stashing a pointer and how are we making sure that
> request queue is around for the lifetime of bdev.

Can you point out a concrete problem in my approach?  This seems
rather vague.

If you have an alternative way to get the 0.3% I would be also
interested.

-Andi
