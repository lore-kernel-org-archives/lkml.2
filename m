Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2KZSxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:53:19 -0500
Received: from science.horizon.com ([71.41.210.146]:59426 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753636Ab2KZSxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:53:18 -0500
Date: 26 Nov 2012 13:53:17 -0500
Message-ID: <20121126185317.10879.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hannes@cmpxchg.org, linux@horizon.com
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Cc: dave@linux.vnet.ibm.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de, riel@redhat.com
In-Reply-To: <20121126183242.GA9894@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> wrote:
> Any chance you could test with this fix instead, in addition to Dave's
> accounting fix?  It's got bool and everything!

Okay.  Mel, speak up if you object.  I also rebased on top of 3.7-rc7,
which already includes Dave's fix.  Again, speak up if that's a bad idea.

> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: vmscan: fix endless loop in kswapd balancing
