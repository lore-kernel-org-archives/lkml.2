Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2GaRA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:00:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2GaRA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:00:56 -0400
Date: Tue, 31 Jul 2012 18:00:51 +0100
From: Mel Gorman <mgorman@suse.de>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Nai Xia <nai.xia@gmail.com>, Johannes Weiner <jweiner@redhat.com>
Subject: Re: [ 06/73] mm: compaction: introduce sync-light migration for use
 by compaction
Message-ID: <20120731170051.GS612@suse.de>
References: <20120731044310.013763753@decadent.org.uk>
 <20120731044311.917959946@decadent.org.uk>
 <20120731164203.GD3111@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120731164203.GD3111@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 01:42:04PM -0300, Herton Ronaldo Krzesinski wrote:
> On Tue, Jul 31, 2012 at 05:43:16AM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mel Gorman <mgorman@suse.de>
> > 
> > commit a6bc32b899223a877f595ef9ddc1e89ead5072b8 upstream.
> 
> We need also to pick recent fix dc32f63453f56d07a1073a697dcd843dd3098c09 after
> applying this one.
> 

mel@machina:~/git-public/linux-2.6 > git remote update
Fetching linux-next
Fetching stable
Fetching net-next
mel@machina:~/git-public/linux-2.6 > git show dc32f63453f56d07a1073a697dcd843dd3098c09
fatal: bad object dc32f63453f56d07a1073a697dcd843dd3098c09

What commit is this, where did it come from and why is it needed?

-- 
Mel Gorman
SUSE Labs
