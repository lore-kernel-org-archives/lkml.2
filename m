Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1IHJWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:22:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36552 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab1IHJWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:22:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Sep 2011 18:21:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: drain all stocks for the cgroup before read
 usage
Message-Id: <20110908182155.f4701bbf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110908004906.GA8499@shutemov.name>
References: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
	<20110905085913.8f84278e.kamezawa.hiroyu@jp.fujitsu.com>
	<20110905101607.cd946a46.nishimura@mxp.nes.nec.co.jp>
	<20110907213340.GA7690@shutemov.name>
	<20110908091914.6daeab1e.kamezawa.hiroyu@jp.fujitsu.com>
	<20110908004906.GA8499@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 03:49:07 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Thu, Sep 08, 2011 at 09:19:14AM +0900, KAMEZAWA Hiroyuki wrote:
> > > Should we have field 'ram' (or 'memory') for rss+cache in memory.stat?
> > > 
> > 
> > Why do you think so ?
> 
> It may be useful for scripting purpose. Just an idea.
> 

Hmm, if you really want, please post a patch.
(in other thread)
I have no strong objection.

Thanks,
-Kame

