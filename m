Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1FTRAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:00:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:35415 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab1FTRAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:00:01 -0400
Date: Mon, 20 Jun 2011 17:59:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: make the threshold of enabling THP configurable
Message-ID: <20110620165955.GB9396@suse.de>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
 <1308587683-2555-2-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1308587683-2555-2-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:34:29AM +0800, Amerigo Wang wrote:
> Don't hard-code 512M as the threshold in kernel, make it configruable,
> and set 512M by default.
> 

I'm not seeing the gain here either. This is something that is going to
be set by distributions and probably never by users. If the default of
512 is incorrect, what should it be? Also, the Kconfig help message has
spelling errors.

-- 
Mel Gorman
SUSE Labs
