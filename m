Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab0DOHvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:51:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0DOHva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:51:30 -0400
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
From: Peter Zijlstra <peterz@infradead.org>
To: Salman <sqazi@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       svaidy@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
       arjan@infradead.org, csadler@google.com, ranjitm@google.com,
       kenchen@google.com, dawnchen@google.com
In-Reply-To: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 09:51:26 +0200
Message-ID: <1271317886.32749.69.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 17:08 -0700, Salman wrote:
> As we discussed earlier this year, Google has an implementation that it
> would like to share.  I have finally gotten around to porting it to
> v2.6.33 and cleaning up the interfaces.  It is provided in the following
> messages for your review.  I realize that when we first discussed this
> idea, a lot of ideas were presented for enhancing it.  Thanks alot for
> your suggestions.  I haven't gotten around to implementing any of them.

.33 is way too old to submit patches against.

That said, I really really dislike this approach, I would much rather
see it tie in with power aware scheduling.

