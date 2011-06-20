Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1FTSAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:00:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab1FTSAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:00:00 -0400
Date: Mon, 20 Jun 2011 13:59:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Cong Wang <amwang@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by
 transparent_hugepage=never
Message-ID: <20110620175952.GD4749@redhat.com>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
 <20110620165844.GA9396@suse.de>
 <4DFF7E3B.1040404@redhat.com>
 <4DFF7F0A.8090604@redhat.com>
 <4DFF8106.8090702@redhat.com>
 <4DFF8327.1090203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF8327.1090203@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 01:28:07PM -0400, Rik van Riel wrote:

[..]
> I'm not convinced that a 10kB memory reduction is
> worth the price of never being able to enable
> transparent hugepages when a system is booted with
> THP disabled...

Agreed.

Thanks
Vivek
