Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2AEGKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:10:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43120 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2AEGKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:10:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Jan 2012 15:09:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: fix typo in isolating lru pages
Message-Id: <20120105150933.eff44480.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAJd=RBAp=ooYGoDqJG0qkUhRuYTsSKG9h+bUvC0dvuVCvfkCgQ@mail.gmail.com>
References: <CAJd=RBAp=ooYGoDqJG0qkUhRuYTsSKG9h+bUvC0dvuVCvfkCgQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Dec 2011 20:38:41 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> It is not the tag page but the cursor page that we should process, and it looks
> a typo.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Hugh Dickins <hughd@google.com>

Nice.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


