Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2JBUQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:16:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab2JBUQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:16:38 -0400
Date: Tue, 2 Oct 2012 16:16:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk
Subject: Re: [dm-devel] [PATCH v3 11/26] block: Add submit_bio_wait(), remove
 from md
Message-ID: <20121002201630.GI758@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-12-git-send-email-koverstreet@google.com>
 <20121002194132.GF3283@redhat.com>
 <20121002201105.GL26488@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002201105.GL26488@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:11:05PM -0700, Kent Overstreet wrote:
> On Tue, Oct 02, 2012 at 03:41:32PM -0400, Vivek Goyal wrote:
> > On Mon, Sep 24, 2012 at 03:34:51PM -0700, Kent Overstreet wrote:
> > > Random cleanup - this code was duplicated and it's not really specific
> > > to md.
> > > 
> > > Also added the ability to return the actual error code.
> > 
> > Who is going to make use of actual error code and why checking
> > BIO_UPTODATE is not sufficient (as existing code is doing)?
> 
> Some things do, though it's not common and I forget where I saw it -
> checking for -ENOTSUPPORTED vs. other stuff

May be we can introduce "submit_bio_ret" stuff when we find the actual
user in the series. Justifying code change becomes easier. 

Thanks
Vivek

