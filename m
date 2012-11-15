Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab2KOCGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:06:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39816 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2KOCGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:06:44 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A44E0F.6030404@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 11:06:07 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] res_counter: delete res_counter_write()
References: <1352938017-32568-1-git-send-email-gthelen@google.com>
In-Reply-To: <1352938017-32568-1-git-send-email-gthelen@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/15 9:06), Greg Thelen wrote:
> Since 628f423553 "memcg: limit change shrink usage" both
> res_counter_write() and write_strategy_fn have been unused.  This
> patch deletes them both.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Thank you
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


