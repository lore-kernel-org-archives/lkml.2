Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2JSBOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:14:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33041 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2JSBOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:14:50 -0400
Date: Thu, 18 Oct 2012 18:14:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de, vgoyal@redhat.com
Subject: Re: [PATCH v4 00/24] Prep work for immutable bio vecs
Message-ID: <20121019011445.GJ13370@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 15, 2012 at 01:08:34PM -0700, Kent Overstreet wrote:
> Since last time - split bio integrity stuff out into its own 2 patch series.
> 
> Also changed bio_advance() a bit - it now explicitly special cases discard and
> WRITE_SAME requests, so that partial completions will work. Previously, partial
> completions worked for other requests but would've silently blown up for those
> - this'll be of use later too, for generic bio splitting.
> 
> I've got 3 patch series queued up but they all should be independent - git tree
> is at
> 
> http://evilpiepirate.org/git/linux-bcache.git for-jens
> 
> It's on top of jens' for-next branch.

Your patch series posting is messed up somehow.  I'm gonna review from
the git branch and post comments here but you'll probably have to post
them again.

Thanks.

-- 
tejun
