Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0IEQb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:31:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab0IEQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:31:55 -0400
Date: Sun, 5 Sep 2010 09:36:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        "btrfs-devel" <btrfs-devel@oss.oracle.com>,
        Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>
Subject: Re: [Btrfs-devel] [patch] O_DIRECT: fix the splitting up of
 contiguous I/O
Message-Id: <20100905093620.d2eeb539.akpm@linux-foundation.org>
In-Reply-To: <201009052256.12386.chris@csamuel.org>
References: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com>
	<20100902142501.GA14932@infradead.org>
	<201009052256.12386.chris@csamuel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Sep 2010 22:56:08 +1000 Chris Samuel <chris@csamuel.org> wrote:

> On Fri, 3 Sep 2010 12:25:01 am Christoph Hellwig wrote:
> 
> > Andrew, can you please send this on to Linus and -stable ASAP?
> > It's causing massive problems for our users.
> 
> Did this patch get dropped ? 

Nope.  I have it queued for 2.6.36 and -stable, will send it in soon. 
Everything is a bit lagged at present due to conferences, summer,
encroaching senility, etc.
