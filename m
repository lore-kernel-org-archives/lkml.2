Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0FDIMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:12:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36603 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0FDIMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:12:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Jun 2010 17:07:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH] memcg fix wake up in oom wait queue
Message-Id: <20100604170757.14af6bb5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100604115820.d7ec1008.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100603172353.b5375879.kamezawa.hiroyu@jp.fujitsu.com>
	<20100604100811.31c45828.nishimura@mxp.nes.nec.co.jp>
	<20100604115820.d7ec1008.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 11:58:20 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Tested on mmotm-2010-06-03 and works well.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> OOM-waitqueue should be waken up when oom_disable is canceled.
> This is a fix for
>  memcg-oom-kill-disable-and-oom-status.patch
> 
Sorry, I found linux-2.6.git has the oom_control patch, so this patch
should be against linux-2.6.git. But maybe no HUNK, I think.

Regards,
-Kame

