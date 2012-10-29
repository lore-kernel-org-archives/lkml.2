Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab2J2KCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:02:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169Ab2J2KCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:02:08 -0400
Date: Mon, 29 Oct 2012 11:01:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
In-Reply-To: <20121029095819.GA4326@liondog.tnic>
Message-ID: <alpine.LNX.2.00.1210291100470.19184@pobox.suse.cz>
References: <20121012125708.GJ10110@dhcp22.suse.cz> <20121024210600.GA17037@liondog.tnic> <20121024141303.0797d6a1.akpm@linux-foundation.org> <1787395.7AzIesGUbB@vostro.rjw.lan> <20121024181752.de011615.akpm@linux-foundation.org> <alpine.LRH.2.00.1210290958450.10392@twin.jikos.cz>
 <20121029095819.GA4326@liondog.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Borislav Petkov wrote:

> > You might or might not want to do that. Dropping caches around suspend
> > makes the hibernation process itself faster, but the realtime response
> > of the applications afterwards is worse, as everything touched by user
> > has to be paged in again.
> 
> Right, do you know of a real use-case where people hibernate, then
> resume and still care about applications response time right afterwards?

Well if the point of dropping caches is lowering the resume time, then the 
point is rendered moot as soon as you switch to your browser and have to 
wait noticeable amount of time until it starts reacting.

-- 
Jiri Kosina
SUSE Labs
