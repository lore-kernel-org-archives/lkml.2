Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2KNGOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:14:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2KNGOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:14:49 -0500
Date: Wed, 14 Nov 2012 01:14:37 -0500
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: fix shmem_getpage_gfp VM_BUG_ON
Message-ID: <20121114061437.GA23458@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Jaegeuk Hanse <jaegeuk.hanse@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1211011546090.19377@eggly.anvils>
 <20121101232030.GA25519@redhat.com>
 <alpine.LNX.2.00.1211011627120.19567@eggly.anvils>
 <20121102014336.GA1727@redhat.com>
 <alpine.LNX.2.00.1211021606580.11106@eggly.anvils>
 <alpine.LNX.2.00.1211051729590.963@eggly.anvils>
 <20121106135402.GA3543@redhat.com>
 <alpine.LNX.2.00.1211061521230.6954@eggly.anvils>
 <50A30ADD.9000209@gmail.com>
 <alpine.LNX.2.00.1211131935410.30540@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211131935410.30540@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 07:50:25PM -0800, Hugh Dickins wrote:
 
 > Originally I was waiting to hear further from Dave; but his test
 > machine was giving trouble, and it occurred to me that, never mind
 > whether he says he has hit it again, or he has not hit it again,
 > the answer is the same: don't send that VM_BUG_ON upstream.
 
Sorry, I'm supposedly on vacation. 
That said, a replacement test box has been running tests since last Friday
without hitting that case.  Maybe it was the last death throes of
that other machine before it gave up the ghost completely.

Does sound like an awful coincidence though.

	Dave

