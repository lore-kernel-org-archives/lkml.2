Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2CIB3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:29:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44681 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2CIB3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:29:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Mar 2012 10:28:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] mm: push lru index into shrink_[in]active_list()
Message-Id: <20120309102805.fe90409b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120308180410.27621.90384.stgit@zurg>
References: <20120308175752.27621.54781.stgit@zurg>
	<20120308180410.27621.90384.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 22:04:10 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Let's toss lru index through call stack to isolate_lru_pages(),
> this is better than its reconstructing from individual bits.
> 
> v5:
> * move patch upper
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

