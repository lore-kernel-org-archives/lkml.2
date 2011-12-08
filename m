Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1LHTXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:23:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab1LHTXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:23:15 -0500
Date: Thu, 8 Dec 2011 23:20:14 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: remove superfluous debug output
Message-ID: <20111208192014.GA9794@albatros>
References: <201111220034.pAM0YHCC015781@wpaz9.hot.corp.google.com>
 <20111125152601.GA2783@p183.telecom.by>
 <20111205113545.GA5831@albatros>
 <20111206164840.b634b1d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206164840.b634b1d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 16:48 -0800, Andrew Morton wrote:
> > -	pr_debug("proc: options = %s\n", options);
> > -
> >  	if (!options)
> >  		return 1;
> 
> So it turns out that this patch is a fix against the pending
> procfs-add-hidepid=-and-gid=-mount-options.patch.  Please tell people
> this sort of thing to prevent confusion.

Oops, sorry.  Will do this next time.


> Also, I have a note here that Alexey has issues with
> procfs-add-hidepid=-and-gid=-mount-options.patch (it is reproduced
> below) - he suggests that it is using incorrect types.  Where do we
> stand with that?

This is not a bug, surely.  IMHO, it's better to have it as the longest
possible format for the future changes.  It's wearily to find such %d
for pid_t instances all over the kernel if we change pid_t from int to
long.

The same question, btw:

http://www.spinics.net/lists/kernel/msg1270730.html

Probably it's better to add official point about this issue into
Documentation/ ?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
