Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab2JBULL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:11:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44395 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2JBULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:11:09 -0400
Date: Tue, 2 Oct 2012 13:11:05 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk
Subject: Re: [dm-devel] [PATCH v3 11/26] block: Add submit_bio_wait(), remove
 from md
Message-ID: <20121002201105.GL26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-12-git-send-email-koverstreet@google.com>
 <20121002194132.GF3283@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002194132.GF3283@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 03:41:32PM -0400, Vivek Goyal wrote:
> On Mon, Sep 24, 2012 at 03:34:51PM -0700, Kent Overstreet wrote:
> > Random cleanup - this code was duplicated and it's not really specific
> > to md.
> > 
> > Also added the ability to return the actual error code.
> 
> Who is going to make use of actual error code and why checking
> BIO_UPTODATE is not sufficient (as existing code is doing)?

Some things do, though it's not common and I forget where I saw it -
checking for -ENOTSUPPORTED vs. other stuff
