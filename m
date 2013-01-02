Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3ABUrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:47:15 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:42580 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab3ABUrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:47:13 -0500
Date: Wed, 2 Jan 2013 20:47:12 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20130102204712.GA17806@dcvr.yhbt.net>
References: <20121228014503.GA5017@dcvr.yhbt.net>
 <20130102200848.GA4500@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102200848.GA4500@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> [1] my full setup is very strange.
> 
>     Other than the FUSE component I forgot to mention, little depends on
>     the kernel.  With all this, the standalone toosleepy can get stuck.
>     I'll try to reproduce it with less...

I just confirmed my toosleepy processes will get stuck while just
doing "rsync -a" between local disks.  So this does not depend on
sendfile or FUSE to reproduce.
