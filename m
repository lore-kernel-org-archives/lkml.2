Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab0FCGhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:37:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39802 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab0FCGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:37:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 3 Jun 2010 15:33:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 07/12] oom: Fix child process iteration properly
Message-Id: <20100603153318.ebf7972c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100603152304.725C.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
	<20100603152304.725C.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Jun 2010 15:23:50 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Oleg pointed out that current oom child process iterating logic is wrong.
> 
>   > list_for_each_entry(p->children) can only see the tasks forked
>   > by p, it can't see other children forked by its sub-threads.
> 
> This patch fixes it.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


