Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1EPII0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:08:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51603 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1EPIIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:08:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 16 May 2011 17:01:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, minchan.kim@gmail.com, riel@redhat.com
Subject: Re: [PATCH 1/3] vmscan,memcg: memcg aware swap token
Message-Id: <20110516170139.332fe31d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4DCD189D.2000207@jp.fujitsu.com>
References: <4DCD1824.1060801@jp.fujitsu.com>
	<4DCD189D.2000207@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 20:40:13 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Currently, memcg reclaim can disable swap token even if the swap token
> mm doesn't belong in its memory cgroup. It's slightly risky. If an
> admin creates very small mem-cgroup and silly guy runs contentious heavy
> memory pressure workload, every tasks are going to lose swap token and
> then system may become unresponsive. That's bad.
> 
> This patch adds 'memcg' parameter into disable_swap_token(). and if
> the parameter doesn't match swap token, VM doesn't disable it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thank you

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

