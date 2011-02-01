Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1BAKJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:09:28 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:48261 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab1BAKJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:09:14 -0500
Date: Tue, 1 Feb 2011 11:09:12 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 4/6] pass pte size argument in to smaps_pte_entry()
Message-ID: <20110201100912.GJ19534@cmpxchg.org>
References: <20110201003357.D6F0BE0D@kernel>
 <20110201003402.5FFC58F0@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201003402.5FFC58F0@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:34:02PM -0800, Dave Hansen wrote:
> 
> This patch adds an argument to the new smaps_pte_entry()
> function to let it account in things other than PAGE_SIZE
> units.  I changed all of the PAGE_SIZE sites, even though
> not all of them can be reached for transparent huge pages,
> just so this will continue to work without changes as THPs
> are improved.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
