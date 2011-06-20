Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1FTQ6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:58:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:35383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab1FTQ6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:58:51 -0400
Date: Mon, 20 Jun 2011 17:58:45 +0100
From: Mel Gorman <mgorman@suse.de>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by
 transparent_hugepage=never
Message-ID: <20110620165844.GA9396@suse.de>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1308587683-2555-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:34:28AM +0800, Amerigo Wang wrote:
> transparent_hugepage=never should mean to disable THP completely,
> otherwise we don't have a way to disable THP completely.
> The design is broken.
> 

I don't get why it's broken. Why would the user be prevented from
enabling it at runtime?

-- 
Mel Gorman
SUSE Labs
