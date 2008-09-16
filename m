Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2HSVnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 17:43:03 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:25889 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2HSVnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 17:43:00 -0400
Date: Tue, 16 Sep 2008 18:36:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Tony Finch <dot@dotat.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unifdef: set a secure umask before calling mkstemp()
In-Reply-To: <alpine.LSU.2.00.1208180025311.29492@hermes-1.csi.cam.ac.uk>
Message-ID: <alpine.LNX.2.00.0809161835530.6202@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1208172136490.15699@swampdragon.chaosbits.net> <alpine.LSU.2.00.1208180025311.29492@hermes-1.csi.cam.ac.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2012, Tony Finch wrote:

> Jesper Juhl <jj@chaosbits.net> wrote:
> 
> > In newer glibc's (versions > 2.06) reasonably secure permissions of
> > 0600 are used when creating a temporary file with mkstemp(). But for
> > older glibc's (versions <= 2.06) 0666 is used which is not secure.
> 
> Thanks for your suggestion! I'm afraid I prefer not to make the change.
> 
> Unifdef is only using mkstemp as a convenient way to open a file with a
> non-clashing name. It isn't trying to be secure, so it's OK just to rely
> on the user's umask. And I find it hard to care about a bug that was fixed
> 15 years ago.
> 
> I'm also trying to reduce the unixisms in the program for portability
> reasons and this is the most awkward part :-/
> 
Fair enough. :-)

Just ignore the patch.

Have a nice day.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

