Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0K2C0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:26:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53216 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0K2C0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:26:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=n7KKPwtq7v1P5eUB5eD20Wruk4unkUF9JtuacXAWLIenSNsWoV5XJhQUwtzAlkWLOd
         75bRRCp8nIM46uK9+lEgG/aPfrEpAmpFsos4B/5fa768l8CS3YKtxoETDtFCkd6NT4ge
         RTccJsP7SY0JpVqO0e/YJfQunrF++X77lL1aE=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v2 1/3] deactivate invalidated pages
In-Reply-To: <20101129110848.82A8.A69D9226@jp.fujitsu.com>
References: <20101129090514.829C.A69D9226@jp.fujitsu.com> <87pqto3n77.fsf@gmail.com> <20101129110848.82A8.A69D9226@jp.fujitsu.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 28 Nov 2010 21:26:15 -0500
Message-ID: <8739qk3lx4.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 11:13:53 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> I'm not againt DONT_NEED feature. I only said PG_reclaim trick is not
> so effective. Every feature has their own pros/cons. I think the cons
> is too big. Also, nobody have mesured PG_reclaim performance gain. Did you?
> 
Not yet. Finally back from vacation here in the States. I'll try sitting
down to put together a test tonight.

- Ben

