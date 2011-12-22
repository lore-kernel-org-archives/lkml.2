Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab1LVXqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:46:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58135 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab1LVXqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:46:44 -0500
Date: Thu, 22 Dec 2011 15:46:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org,
        x86@kernel.org
Subject: Re: linux-next: Tree for Dec 21
Message-ID: <20111222234639.GS17084@google.com>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
 <20111221151503.4d78f94f.akpm@linux-foundation.org>
 <20111222150836.af172886.akpm@linux-foundation.org>
 <20111222232036.GP17084@google.com>
 <20111222152427.c944c747.akpm@linux-foundation.org>
 <20111222233843.GR17084@google.com>
 <20111222154427.89b245c7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222154427.89b245c7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 03:44:27PM -0800, Andrew Morton wrote:
> > Weird, I can't reproduce the problem on block/for-3.3/core.  Trying
> > linux-next... hmmm, it works there too.
> 
> This machine is next to my desk, about 50 yards from your cube ;)

Heh, physical access feels like such distant concept.  :)

I'll test with the config and if I still can't reproduce it, play with
your machine.

Thanks.

-- 
tejun
