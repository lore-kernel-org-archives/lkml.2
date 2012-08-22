Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab2HVWhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:37:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33491 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2HVWhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:37:39 -0400
Date: Thu, 23 Aug 2012 00:37:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 19/36] autonuma: memory follows CPU algorithm and task/mm_autonuma stats collection
Message-ID: <20120822223733.GQ16230@one.firstfloor.org>
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com> <1345647560-30387-20-git-send-email-aarcange@redhat.com> <m2sjbe7k93.fsf@firstfloor.org> <20120822212459.GC8107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822212459.GC8107@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This comment seems quite accurate to me (btw I taken it from
> sched-numa rewrite with minor changes).

I had expected it to describe the next function. If it's a strategic
overview maybe it should be somewhere else.

> Disabling irqs around lru_lock was an optimization to avoid increasing
> the hold time of the lock when all critical sections were short after
> the isolation code. Now it's used to rotate lrus at I/O completion too.

Thanks.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
