Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab1BAKMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:12:10 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:57376 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1BAKMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:12:09 -0500
Date: Tue, 1 Feb 2011 11:12:07 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 6/6] have smaps show transparent huge pages
Message-ID: <20110201101207.GL19534@cmpxchg.org>
References: <20110201003357.D6F0BE0D@kernel>
 <20110201003405.FC58B813@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201003405.FC58B813@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:34:05PM -0800, Dave Hansen wrote:
> 
> Now that the mere act of _looking_ at /proc/$pid/smaps will not
> destroy transparent huge pages, tell how much of the VMA is
> actually mapped with them.
> 
> This way, we can make sure that we're getting THPs where we
> expect to see them.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
