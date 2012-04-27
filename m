Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2D0Xkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:40:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2D0Xkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:40:46 -0400
Date: Fri, 27 Apr 2012 16:40:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/2] proc: report file/anon bit in /proc/pid/pagemap
Message-Id: <20120427164044.c883d390.akpm@linux-foundation.org>
In-Reply-To: <4F9AA11E.3040800@parallels.com>
References: <4F91BC8A.9020503@parallels.com>
	<20120427123901.2132.47969.stgit@zurg>
	<4F9AA11E.3040800@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 17:37:34 +0400
Pavel Emelyanov <xemul@parallels.com> wrote:

> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Rik van Riel <riel@redhat.com>
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>

hm, I'd have thought this should be From:Pavel and certainly
Signed-off-by:Pavel, but I'll let you guys decide.

Rik acked the earlier version and that isn't reflected here.  I never
know what to do about this.  I usually play it safe and assume that a
change in the patch erases the ack.

Please cc the original pagemap author (Matt Mackall <mpm@selenic.com>)
on these patches.  He's sometimes useful ;)

The patches looked nice to me, but as it appears that Pavel is unhappy
with [2/2] I shall tip this patchset into my bitbucket and shall await
the next rev, thanks.
