Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680Ab1LOWyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:54:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58939 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503Ab1LOWyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:54:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Dec 2011 07:52:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: linux-next: Tree for Dec 15 (memcontrol)
Message-Id: <20111216075254.f4a8fa0f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4EEA8693.8020905@xenotime.net>
References: <20111215191115.fd4ef2ab8fa11872ea22d70e@canb.auug.org.au>
	<4EEA8693.8020905@xenotime.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011 15:45:23 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 12/15/2011 12:11 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20111214:
> 
> 
> memcontrol.c:(.text+0x31f9d): undefined reference to `mem_cgroup_sockets_init'
> memcontrol.c:(.text+0x326dd): undefined reference to `mem_cgroup_sockets_destroy'
> 
> Full randconfig file is attached.
> 

Added Glauber Costa <glommer@parallels.com> to CC.

THanks,
-Kame

