Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab0FULqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:46:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58842 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab0FULpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:45:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/9] oom: cleanup has_intersects_mems_allowed()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1006162119540.14101@chino.kir.corp.google.com>
References: <20100617104719.FB8C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006162119540.14101@chino.kir.corp.google.com>
Message-Id: <20100617134601.FBA7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 21 Jun 2010 20:45:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:
> 
> > 
> > Now has_intersects_mems_allowed() has own thread iterate logic, but
> > it should use while_each_thread().
> > 
> > It slightly improve the code readability.
> > 
> > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> I disagree that the renaming of the variables is necessary, please simply 
> change the while (tsk != start) to use while_each_thread(tsk, start);

This is common naming rule of while_each_thread(). please grep.



