Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1LZH3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 02:29:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54061 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1LZH3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 02:29:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 16:28:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: hugetlb: avoid bogus counter of surplus huge page
Message-Id: <20111226162813.fee00d84.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAJd=RBCS3-PoFa3FUVwhiznPTQH5xq7fTYa3m01a0-buACQbCA@mail.gmail.com>
References: <CAJd=RBCS3-PoFa3FUVwhiznPTQH5xq7fTYa3m01a0-buACQbCA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011 21:38:38 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> From: Hillf Danton <dhillf@gmail.com>
> Subject: [PATCH] mm: hugetlb: avoid bogus counter of surplus huge page
> 
> If we have to hand back the newly allocated huge page to page allocator,
> for any reason, the changed counter should be recovered.
> 
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

