Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2JJARg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:17:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2JJAR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:17:29 -0400
Date: Tue, 9 Oct 2012 17:17:26 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 3/5] aio: Rewrite refcounting
Message-ID: <20121010001726.GD26835@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-3-git-send-email-koverstreet@google.com>
 <20121009182755.GN26187@lenny.home.zabbo.net>
 <20121009222153.GG29494@google.com>
 <20121009223504.GS26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009223504.GS26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 03:35:04PM -0700, Zach Brown wrote:
> > Alright... send it out then.
> 
> Workin' on it! :)
> 
> > Also, do you know which branch Jens has his patches in?
> 
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=6b6723fc3e4f24dbd80526df935ca115ead578c6
> 
> https://plus.google.com/111643045511375507360/posts
> 
> As far as I know, he hasn't had a chance to work on it recently.

Thanks - wasn't sure if I was looking at the right branch. Looking at it
now...
