Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab1LZHCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 02:02:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59062 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1LZHBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 02:01:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 16:00:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: hugetlb: undo change to page mapcount in fault
 handler
Message-Id: <20111226160041.df3b6f2c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAJd=RBBY0sKdtdx9d8KXTchjaN6au0_hvMfE2+9JkdhvJe7eAw@mail.gmail.com>
References: <CAJd=RBBF=K5hHvEwb6uwZJwS4=jHKBCNYBTJq-pSbJ9j_ZaiaA@mail.gmail.com>
	<20111222163604.GB14983@tiehlicka.suse.cz>
	<CAJd=RBBY0sKdtdx9d8KXTchjaN6au0_hvMfE2+9JkdhvJe7eAw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011 21:00:41 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Fri, Dec 23, 2011 at 12:36 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > The changelog is rather cryptic. What about something like:
> >
> 
> It is included in the following version, thanks.
> 
> ===CUT HERE===
> From: Hillf Danton <dhillf@gmail.com>
> Subject: [PATCH] mm: hugetlb: undo change to page mapcount in fault handler
> 
> Page mapcount should be updated only if we are sure that the page ends
> up in the page table otherwise we would leak if we couldn't COW due to
> reservations or if idx is out of bounds.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

