Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1BAKI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:08:29 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:48256 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab1BAKI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:08:26 -0500
Date: Tue, 1 Feb 2011 11:08:23 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 3/6] break out smaps_pte_entry() from
 smaps_pte_range()
Message-ID: <20110201100823.GI19534@cmpxchg.org>
References: <20110201003357.D6F0BE0D@kernel>
 <20110201003401.95CFBFA6@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201003401.95CFBFA6@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:34:01PM -0800, Dave Hansen wrote:
> 
> We will use smaps_pte_entry() in a moment to handle both small
> and transparent large pages.  But, we must break it out of
> smaps_pte_range() first.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
