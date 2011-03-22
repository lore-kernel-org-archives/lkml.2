Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1CVFC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 01:02:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45702 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1CVFCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 01:02:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 22 Mar 2011 13:56:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memcg: move page-freeing code outside of lock
Message-Id: <20110322135619.90593f5d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1300763079.1483.21.camel@leonhard>
References: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
	<1300452855-10194-3-git-send-email-namhyung@gmail.com>
	<20110322085938.0691f7f4.kamezawa.hiroyu@jp.fujitsu.com>
	<1300763079.1483.21.camel@leonhard>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 12:04:39 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> 2011-03-22 (화), 08:59 +0900, KAMEZAWA Hiroyuki:
> > On Fri, 18 Mar 2011 21:54:15 +0900
> > Namhyung Kim <namhyung@gmail.com> wrote:
> > 
> > > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > What is the benefit of this patch ?
> > 
> > -Kame
> > 
> 
> Oh, I just thought generally it'd better call such a (potentially)
> costly function outside of locks and it could reduce few of theoretical
> contentions between swapons and/or offs. If it doesn't help any
> realistic cases I don't mind discarding it.
> 

My point is, please write patch description which shows for what this patc is.
All cleanup are okay to me if it reasonable. But without patch description as
"this is just a cleanup, no functional change, and the reason is...."
we cannot maintain patches.

Thanks,
-Kame

