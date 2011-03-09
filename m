Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1CIGNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:13:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42581 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1CIGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:13:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Mar 2011 15:06:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Vagin <avagin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable()
Message-Id: <20110309150656.c7128fdd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4D75E4E6.9020507@gmail.com>
References: <1299325456-2687-1-git-send-email-avagin@openvz.org>
	<20110305152056.GA1918@barrios-desktop>
	<4D72580D.4000208@gmail.com>
	<20110305155316.GB1918@barrios-desktop>
	<4D7267B6.6020406@gmail.com>
	<20110305170759.GC1918@barrios-desktop>
	<20110307135831.9e0d7eaa.akpm@linux-foundation.org>
	<20110308094438.1ba05ed2.kamezawa.hiroyu@jp.fujitsu.com>
	<4D75E4E6.9020507@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Mar 2011 11:12:22 +0300
Andrew Vagin <avagin@gmail.com> wrote:

> Hi, All
> > I agree with Minchan and can't think this is a real fix....
> > Andrey, I'm now trying your fix and it seems your fix for oom-killer,
> > 'skip-zombie-process' works enough good for my environ.
> >
> > What is your enviroment ? number of cpus ? architecture ? size of memory ?
> Processort: AMD Phenom(tm) II X6 1055T Processor (six-core)
> Ram: 8Gb
> RHEL6, x86_64. This host doesn't have swap.
> 
Ok, thanks. "NO SWAP" is a big information ;)

> It hangs up fast. Tomorrow I will have to send a processes state, if it 
> will be interesting for you. With my patch the kernel work fine. I added 
> debug and found that it hangs up in the described case.
> I suppose that my patch may be incorrect, but the problem exists and we 
> should do something.
>

Thanks,
-Kame

