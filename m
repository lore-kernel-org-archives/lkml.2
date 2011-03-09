Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1CIFuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 00:50:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40374 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1CIFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 00:50:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Mar 2011 14:43:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable()
Message-Id: <20110309144353.387d946e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110309143704.194e8ee1.kamezawa.hiroyu@jp.fujitsu.com>
References: <1299325456-2687-1-git-send-email-avagin@openvz.org>
	<20110305152056.GA1918@barrios-desktop>
	<4D72580D.4000208@gmail.com>
	<20110305155316.GB1918@barrios-desktop>
	<4D7267B6.6020406@gmail.com>
	<20110305170759.GC1918@barrios-desktop>
	<20110307135831.9e0d7eaa.akpm@linux-foundation.org>
	<AANLkTinDhorLusBju=Gn3bh1VsH1jrv0qixbU3SGWiqa@mail.gmail.com>
	<20110309143704.194e8ee1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 14:37:04 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 8 Mar 2011 08:45:51 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> Hmm, should I support a sacrifice feature 'some signal(SIGINT?) will be sent by
> the kernel when it detects system memory is in short' in cgroup ?
> (For example, if full LRU scan is done in a zone, notifier
>  works and SIGINT will be sent.)
> 

Sorry, this sounds like  "mem_notify" ;), Kosaki-san's old work.

I think functionality for "mem_notify" will have no obstacle opinion but
implementation detail is a problem....Shouldn't we try it again ?

Thanks,
-Kame

