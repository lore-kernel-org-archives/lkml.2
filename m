Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2ALLOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 06:14:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab2ALLOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 06:14:20 -0500
Date: Thu, 12 Jan 2012 11:14:15 +0000
From: Mel Gorman <mgorman@suse.de>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: __count_immobile_pages make sure the node is online
Message-ID: <20120112111415.GH4118@suse.de>
References: <1326213022-11761-1-git-send-email-mhocko@suse.cz>
 <alpine.DEB.2.00.1201101326080.10821@chino.kir.corp.google.com>
 <20120111084802.GA16466@tiehlicka.suse.cz>
 <20120112111702.3b7f2fa2.kamezawa.hiroyu@jp.fujitsu.com>
 <20120112082722.GB1042@tiehlicka.suse.cz>
 <20120112173536.db529713.kamezawa.hiroyu@jp.fujitsu.com>
 <20120112092314.GC1042@tiehlicka.suse.cz>
 <20120112183323.1bb62f4d.kamezawa.hiroyu@jp.fujitsu.com>
 <20120112100521.GD1042@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120112100521.GD1042@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:05:21AM +0100, Michal Hocko wrote:
> From 39de8df13532150fc4518dad0cb3f6fd88745b8a Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Thu, 12 Jan 2012 10:19:04 +0100
> Subject: [PATCH] mm: __count_immobile_pages make sure the node is online
> 
> page_zone requires to have an online node otherwise we are accessing
> NULL NODE_DATA. This is not an issue at the moment because node_zones
> are located at the structure beginning but this might change in the
> future so better be careful about that.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Mel Gorman <mgorman@suse.de>

Be aware that this is not the version picked up by Andrew. It would
not hurt to resend as V2 with a changelog and a note saying it replaces
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch in mmotm.
This is just in case the wrong one gets merged due to this thread
getting lost in the noise of Andrew's inbox.

-- 
Mel Gorman
SUSE Labs
