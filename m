Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2CBFdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:33:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41882 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2CBFdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:33:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Mar 2012 14:32:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] mm/memcg: use vm_swappiness from target memory
 cgroup
Message-Id: <20120302143220.ac7fcc53.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120229091604.29236.63600.stgit@zurg>
References: <20120229090748.29236.35489.stgit@zurg>
	<20120229091604.29236.63600.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 13:16:04 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Use vm_swappiness from memory cgroup which is triggered this memory reclaim.
> This is more reasonable and allows to kill one argument.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

seems reasonable to me.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

