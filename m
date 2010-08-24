Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0HXUIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:08:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab0HXUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:08:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=TO6CPZnLynRBeKTZjlXl9nfN3otXYMciwQ2NkxX9WRH/pCpcwVMK53De6GwNUa+2n
	TMuxCLE/BKsHeHEP79ouQ==
Date: Tue, 24 Aug 2010 13:08:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, cluster-devel@redhat.com,
        linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
In-Reply-To: <1282656558.2605.2742.camel@laptop>
Message-ID: <alpine.DEB.2.00.1008241307190.21242@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Peter Zijlstra wrote:

> > These were added as helper functions for documentation and auditability.
> > No future callers should be added.
> 
> git grep GFP_NOFAIL isn't auditable enough?
> 

I'm trying to remove that bit, and __GFP_REPEAT, to simplify and remove 
several branches from the page allocator.

> might as well declare these functions depricated if you really want to
> do this.
> 
> FWIW I think mason said he'd fix btrfs to not suck like this 'soon'.
> 

Great!
