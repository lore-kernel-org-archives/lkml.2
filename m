Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab1ELQJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:09:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab1ELQJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:09:33 -0400
Date: Thu, 12 May 2011 12:08:30 -0400
From: Dave Jones <davej@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Message-ID: <20110512160830.GA16345@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
 <1305127773-10570-4-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.00.1105120942050.24560@router.home>
 <1305213359.2575.46.camel@mulgrave.site>
 <alpine.DEB.2.00.1105121024350.26013@router.home>
 <1305214993.2575.50.camel@mulgrave.site>
 <20110512154649.GB4559@redhat.com>
 <1305216023.2575.54.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305216023.2575.54.camel@mulgrave.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:00:23AM -0500, James Bottomley wrote:
 > On Thu, 2011-05-12 at 11:46 -0400, Dave Jones wrote:
 > > On Thu, May 12, 2011 at 10:43:13AM -0500, James Bottomley wrote:
 > > 
 > >  > As I said above, no released fedora version uses SLUB.  It's only just
 > >  > been enabled for the unreleased FC15; I'm testing a beta copy.
 > > 
 > > James, this isn't true.
 > > 
 > > $ grep SLUB /boot/config-2.6.35.12-88.fc14.x86_64 
 > > CONFIG_SLUB_DEBUG=y
 > > CONFIG_SLUB=y
 > > 
 > > (That's the oldest release I have right now, but it's been enabled even
 > > before that release).
 > 
 > OK, I concede the point ... I haven't actually kept any of my FC
 > machines current for a while.

'a while' is an understatement :)
It was first enabled in Fedora 8 in 2007.

	Dave
 
