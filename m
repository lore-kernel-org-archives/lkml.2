Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab1H2WMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:12:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35001 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab1H2WMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:12:35 -0400
Date: Mon, 29 Aug 2011 23:12:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 8/9] um: fix strrchr problems
Message-ID: <20110829221230.GP2203@ZenIV.linux.org.uk>
References: <1314634419-24766-1-git-send-email-richard@nod.at>
 <1314634419-24766-9-git-send-email-richard@nod.at>
 <20110829142705.5be82d7c.akpm@linux-foundation.org>
 <4E5C06DF.60508@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5C06DF.60508@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:38:39PM +0200, Richard Weinberger wrote:
> >
> >ok, I give up.  How does this work?
> 
> *grrr*, you can drop this patch.
> To my excuse, I've dropped it already from my queue but after
> pulling a second time from Al's git branch it made it again into my
> queue and I forgot about it, sorry!

That gets you link errors with libc-2.11...
