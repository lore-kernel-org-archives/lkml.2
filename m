Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab2IUEw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 00:52:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60507 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2IUEwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 00:52:20 -0400
Date: Thu, 20 Sep 2012 21:51:46 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 23/26] raid1: use bio_alloc_pages()
Message-ID: <20120921045146.GB29160@moria.home.lan>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-24-git-send-email-koverstreet@google.com>
 <20120921004827.GA7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921004827.GA7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 05:48:27PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:34PM -0700, Kent Overstreet wrote:
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: NeilBrown <neilb@suse.de>
> 
> I think it's better to merge this and the previous patch.  It's not
> like we're converting a lot of users.

Ok, will do.
