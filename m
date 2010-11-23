Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab0KWHRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:17:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37375 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0KWHRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:17:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
Cc: kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1011141341360.22262@chino.kir.corp.google.com>
References: <20101114140237.E010.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141341360.22262@chino.kir.corp.google.com>
Message-Id: <20101123160818.7B9F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:
> 
> > I've sent revert patch to linus. We DON'T want to break any userland seriously. 
> > So, we reconsider about this area. personally I hope to reintroduce oom_score_adj
> > later, but It must don't break current userland.
> > 
> 
> Nobody is going to stall their development waiting for your patches to be 
> merged (especially when you've proposed them four times before and they 
> haven't been), so patches in this area should be against Linus' latest 
> tree.

Nobody want to accept you break userland.


