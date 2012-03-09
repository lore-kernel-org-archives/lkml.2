Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab2CIBfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:35:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38647 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2CIBfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:35:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Mar 2012 10:33:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 7/7] mm/memcg: use vm_swappiness from target memory
 cgroup
Message-Id: <20120309103351.d6757a31.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120308180430.27621.99232.stgit@zurg>
References: <20120308175752.27621.54781.stgit@zurg>
	<20120308180430.27621.99232.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 22:04:30 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Use vm_swappiness from memory cgroup which is triggered this memory reclaim.
> This is more reasonable and allows to kill one argument.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>

Thank you for your works!

