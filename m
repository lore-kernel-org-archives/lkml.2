Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1FMBbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:31:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39077 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab1FMBbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:31:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jun 2011 10:23:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Subject: Re: [BUGFIX][PATCH] memcg: fix wrong decision of noswap with
 softlimit.
Message-Id: <20110613102358.95637755.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110612112228.GC19493@tiehlicka.suse.cz>
References: <20110609095445.5f98b752.kamezawa.hiroyu@jp.fujitsu.com>
	<20110612112228.GC19493@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011 13:22:28 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> Hierarchical reclaim doesn't swap out if memsw and resource limits are
> same (memsw_is_minimum == true) because we would hit mem+swap limit
> anyway (during hard limit reclaim).
> If it comes to the solft limit we shouldn't consider memsw_is_minimum at
> all because it doesn't make much sense. Either the soft limit is bellow
> the hard limit and then we cannot hit mem+swap limit or the direct
> reclaim takes a precedence.

Thank you. I'd like to use your description.

I'll post last week bug fixes series, today.

Thanks,
-Kame

