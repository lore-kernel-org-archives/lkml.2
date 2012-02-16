Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2BPAQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:16:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54039 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2BPAQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:16:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Feb 2012 09:15:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: use vm_swappiness from current memcg
Message-Id: <20120216091511.350882a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120215162834.13902.37262.stgit@zurg>
References: <20120215162830.13902.60256.stgit@zurg>
	<20120215162834.13902.37262.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 20:28:34 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> At this point this is always the same cgroup, but it allows to drop one argument.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Do you mean "no logic change but clean up, dropping an argument" ?

I'm not sure using complicated sc-> is easier than passing an argument..

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

