Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab1ELPq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:46:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692Ab1ELPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:46:56 -0400
Date: Thu, 12 May 2011 11:45:48 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mel Gorman <mgorman@suse.de>,
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
Message-ID: <20110512154548.GA4559@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Lameter <cl@linux.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Mel Gorman <mgorman@suse.de>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105121024350.26013@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:27:00AM -0500, Christoph Lameter wrote:
 > On Thu, 12 May 2011, James Bottomley wrote:
 > > It's only recently that the desktop
 > > distributions started to ... the bugs are showing up under FC15 beta,
 > > which is the first fedora distribution to enable it.  I'd say we're only
 > > just beginning widespread SLUB testing.
 > 
 > Debian and Ubuntu have been using SLUB for a long time (and AFAICT from my
 > archives so has Fedora).

Indeed. It was enabled in Fedora pretty much as soon as it appeared in mainline.

	Dave

