Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966406Ab2FBHXD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 03:23:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51298 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966378Ab2FBHXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 03:23:01 -0400
Date: Sat, 2 Jun 2012 00:22:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
In-Reply-To: <20120602071730.GB329@x4>
Message-ID: <alpine.LSU.2.00.1206020021280.1376@eggly.anvils>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com> <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com>
 <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com> <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <20120602071730.GB329@x4>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2012, Markus Trippelsdorf wrote:
> On 2012.06.01 at 21:40 -0700, Hugh Dickins wrote:
> > 
> > I'm guessing that the few people who see the warning are those running
> > new systemd distros, and that systemd is indeed now making use of the
> > fallocate support we added into tmpfs for it.)
> 
> At least in my case it's nothing that horrible. I'm just setting
> browser.cache.disk.parent_directory to /dev/shm in Firefox. And Firefox
> does indeed use fallocate on its "disk cache" items.

That fits, and it's very helpful to know - thank you.

Hugh
