Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1FULwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:52:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:36889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1FULwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:52:05 -0400
Date: Tue, 21 Jun 2011 13:52:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm: completely disable THP by
 transparent_hugepage=0
Message-ID: <20110621115201.GD8093@tiehlicka.suse.cz>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308643849-3325-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-06-11 16:10:42, Amerigo Wang wrote:
> Introduce "transparent_hugepage=0" to totally disable THP.
> "transparent_hugepage=never" means setting THP to be partially
> disabled, we need a new way to totally disable it.

I am wondering why would you like to disable the feature on per-boot
basis. Does transparent_hugepage=never bring any measurable overhead?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
