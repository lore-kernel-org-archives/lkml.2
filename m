Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1DZI5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:57:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57563 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1DZI5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:57:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 26 Apr 2011 17:50:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: Re: (resend) [PATCH] vmscan,memcg: memcg aware swap token
Message-Id: <20110426175021.c783e57d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110426170146.F396.A69D9226@jp.fujitsu.com>
References: <20110426170146.F396.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 16:59:19 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Currently, memcg reclaim can disable swap token even if the swap token
> mm doesn't belong in its memory cgroup. It's slightly riskly. If an
> admin makes very small mem-cgroup and silly guy runs contenious heavy
> memory pressure workloa, whole tasks in the system are going to lose
> swap-token and then system may become unresponsive. That's bad.
> 
> This patch adds 'memcg' parameter into disable_swap_token(). and if
> the parameter doesn't match swap-token, VM doesn't put swap-token.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Ack. Thank you.

-Kame


