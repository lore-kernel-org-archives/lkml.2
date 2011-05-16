Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1EPIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:09:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51631 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1EPIJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:09:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 16 May 2011 17:02:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, minchan.kim@gmail.com, riel@redhat.com
Subject: Re: [PATCH 2/3] vmscan: implement swap token trace
Message-Id: <20110516170241.d918031e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4DCD18C4.1000902@jp.fujitsu.com>
References: <4DCD1824.1060801@jp.fujitsu.com>
	<4DCD18C4.1000902@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 20:40:52 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> This is useful for observing swap token activity.
> 
> example output:
> 
>              zsh-1845  [000]   598.962716: update_swap_token_priority:
> mm=ffff88015eaf7700 old_prio=1 new_prio=0
>           memtoy-1830  [001]   602.033900: update_swap_token_priority:
> mm=ffff880037a45880 old_prio=947 new_prio=949
>           memtoy-1830  [000]   602.041509: update_swap_token_priority:
> mm=ffff880037a45880 old_prio=949 new_prio=951
>           memtoy-1830  [000]   602.051959: update_swap_token_priority:
> mm=ffff880037a45880 old_prio=951 new_prio=953
>           memtoy-1830  [000]   602.052188: update_swap_token_priority:
> mm=ffff880037a45880 old_prio=953 new_prio=955
>           memtoy-1830  [001]   602.427184: put_swap_token:
> token_mm=ffff880037a45880
>              zsh-1789  [000]   602.427281: replace_swap_token:
> old_token_mm=          (null) old_prio=0 new_token_mm=ffff88015eaf7018
> new_prio=2
>              zsh-1789  [001]   602.433456: update_swap_token_priority:
> mm=ffff88015eaf7018 old_prio=2 new_prio=4
>              zsh-1789  [000]   602.437613: update_swap_token_priority:
> mm=ffff88015eaf7018 old_prio=4 new_prio=6
>              zsh-1789  [000]   602.443924: update_swap_token_priority:
> mm=ffff88015eaf7018 old_prio=6 new_prio=8
>              zsh-1789  [000]   602.451873: update_swap_token_priority:
> mm=ffff88015eaf7018 old_prio=8 new_prio=10
>              zsh-1789  [001]   602.462639: update_swap_token_priority:
> mm=ffff88015eaf7018 old_prio=10 new_prio=12
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


