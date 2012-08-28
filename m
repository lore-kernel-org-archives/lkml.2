Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2H1WEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:04:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59887 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2H1WEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:04:07 -0400
Date: Tue, 28 Aug 2012 15:03:32 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 6/9] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Message-ID: <20120828220332.GA1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-7-git-send-email-koverstreet@google.com>
 <20120828204148.GE24608@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828204148.GE24608@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:41:48PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Tue, Aug 28, 2012 at 10:37:33AM -0700, Kent Overstreet wrote:
> > v7: Re-add dropped comments, improv patch description
> 
> I don't think you did the former part.  Other than that looks good to
> me.

I folded them into the bio_alloc_bioset() comments - so all the
information that was there previously should still be there, just
centralized. That good enough for your acked-by?
