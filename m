Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab0HXOED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:04:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0HXOEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:04:00 -0400
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, cluster-devel@redhat.com,
        linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100824135522.GK31488@dastard>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <1282656558.2605.2742.camel@laptop>  <20100824135522.GK31488@dastard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 16:03:31 +0200
Message-ID: <1282658611.2605.2781.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 23:55 +1000, Dave Chinner wrote:
> no one has noticed
> that XFS has been doing these "allocations can't fail" loop in
> kmem_alloc() and kmem_zone_alloc(), well, forever 

I occasionally check if its still there and cry a little ;-)
