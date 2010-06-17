Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab0FQB4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:56:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34293 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962Ab0FQBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/9] oom: rename badness() to oom_badness()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1006161440360.11089@chino.kir.corp.google.com>
References: <20100616202920.72DA.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006161440360.11089@chino.kir.corp.google.com>
Message-Id: <20100617085336.FB48.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 16 Jun 2010, KOSAKI Motohiro wrote:
> 
> > 
> > badness() is wrong name because it's too generic name. rename it.
> > 
> 
> This is already done in my badness heuristic rewrite, can we please focus 
> on its review?

Please resend that as individual patches. 



