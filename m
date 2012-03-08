Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2CHFnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:43:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55083 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2CHFnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:43:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Mar 2012 14:41:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 2/2] mm, counters: fold __sync_task_rss_stat into
 sync_mm_rss
Message-Id: <20120308144138.d8ace9d3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1203061920370.21806@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061919260.21806@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1203061920370.21806@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 19:21:42 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> There's no difference between sync_mm_rss() and __sync_task_rss_stat(),
> so fold the latter into the former.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

