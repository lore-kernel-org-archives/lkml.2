Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1KWP5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:57:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1KWP5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:57:11 -0500
Date: Wed, 23 Nov 2011 15:57:07 +0000
From: Mel Gorman <mgorman@suse.de>
To: Nai Xia <nai.xia@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] mm: compaction: Introduce sync-light migration for
 use by compaction
Message-ID: <20111123155707.GP19415@suse.de>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
 <1321900608-27687-8-git-send-email-mgorman@suse.de>
 <1321945011.22361.335.camel@sli10-conroe>
 <CAPQyPG4DQCxDah5VYMU6PNgeuD_3WJ-zm8XpL7V7BK8hAF8OJg@mail.gmail.com>
 <20111123110041.GM19415@suse.de>
 <CAPQyPG588_q1diT8KyPirUD9MLME6SanO-cSw1twzhFiTBWgCw@mail.gmail.com>
 <20111123134512.GN19415@suse.de>
 <CAPQyPG6b-MiysHnEadWRX729_q7G=_mYozSR+OatS-TLs_Sw_Q@mail.gmail.com>
 <20111123150810.GO19415@suse.de>
 <CAPQyPG58cjEQ8jPFhxGB6URcFoNt=NBC1L+T8aEWVUtPfBNh-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAPQyPG58cjEQ8jPFhxGB6URcFoNt=NBC1L+T8aEWVUtPfBNh-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:23:19PM +0800, Nai Xia wrote:
> > <SNIP>
> > This would be functionally equivalent and satisfy THP users
> > but I do not see it as being easier to understand or easier
> > to maintain than updating the API. If someone in the future
> > wanted to use migration without significant stalls without
> > being PF_MEMALLOC, they would need to update the API like this.
> > There are no users like this today but automatic NUMA migration
> > might want to leverage something like MIGRATE_SYNC_LIGHT
> > (http://comments.gmane.org/gmane.linux.kernel.mm/70239)
> 
> I see.
> So could I say that might be the time and users for my suggestion of
> page uptodate check to fit into?
> 

Yes, at that point checking for PageUptodate may be necessary depending
on their requirements.

-- 
Mel Gorman
SUSE Labs
