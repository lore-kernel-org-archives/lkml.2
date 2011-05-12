Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab1ELQA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:00:28 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56342 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757331Ab1ELQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:00:26 -0400
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dave Jones <davej@redhat.com>
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
In-Reply-To: <20110512154649.GB4559@redhat.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	 <1305127773-10570-4-git-send-email-mgorman@suse.de>
	 <alpine.DEB.2.00.1105120942050.24560@router.home>
	 <1305213359.2575.46.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121024350.26013@router.home>
	 <1305214993.2575.50.camel@mulgrave.site> <20110512154649.GB4559@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 11:00:23 -0500
Message-ID: <1305216023.2575.54.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 11:46 -0400, Dave Jones wrote:
> On Thu, May 12, 2011 at 10:43:13AM -0500, James Bottomley wrote:
> 
>  > As I said above, no released fedora version uses SLUB.  It's only just
>  > been enabled for the unreleased FC15; I'm testing a beta copy.
> 
> James, this isn't true.
> 
> $ grep SLUB /boot/config-2.6.35.12-88.fc14.x86_64 
> CONFIG_SLUB_DEBUG=y
> CONFIG_SLUB=y
> 
> (That's the oldest release I have right now, but it's been enabled even
> before that release).

OK, I concede the point ... I haven't actually kept any of my FC
machines current for a while.

However, the fact remains that this seems to be a slub problem and it
needs fixing.

James


