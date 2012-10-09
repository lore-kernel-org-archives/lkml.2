Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab2JIVhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:37:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53913 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab2JIVhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:37:03 -0400
Date: Tue, 9 Oct 2012 14:37:00 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Message-ID: <20121009213700.GF29494@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009182625.GM26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:26:25AM -0700, Zach Brown wrote:
> On Mon, Oct 08, 2012 at 11:39:17PM -0700, Kent Overstreet wrote:
> > Minor refactoring, to get rid of some duplicated code
> 
> Honestly: I wouldn't bother.  Nothing of consequence uses cancel.
> 
> I have an RFC patch series that tears it out.  Let me polish that up
> send it out, I'll cc: you.

Even better :)

I've been looking at aio locking the past few days, and I was getting
ready to write something up about cancellation to the lists.

Short version, supporting cancellation without global sychronization is
possible but it'd require help from the allocator.

If we can just rip it out though that'd really make me happy.
