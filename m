Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0DNXBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:01:22 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:16793 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0DNXBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:01:20 -0400
Date: Wed, 14 Apr 2010 16:00:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 0/6] kconfig: add support to show hidden options which
 have prompts
Message-Id: <20100414160043.7ffb1109.randy.dunlap@oracle.com>
In-Reply-To: <4BC539DD.5040003@cn.fujitsu.com>
References: <4BC539DD.5040003@cn.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0208.4BC6492F.01CE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 11:43:25 +0800 Li Zefan wrote:

> I noticed gconfig and xconfig have a button "Show all options",
> but that's a bit too much, and I think normally what we are not
> interested in those configs which have no prompt thus can't be
> changed by users.

Yes, I use that all of the time (i.e., once it has been set, it remains
set for the next execution, so I leave it that way).


> Exmaple:
> 
>       --- Tracers
>       -*-   Kernel Function Tracer
>       - -     Kernel Function Graph Tracer
>       [*]   Interrupts-off Latency Tracer
>       - -   Preemption-off Latency Tracer
>       [*]   Sysprof Tracer
> 
> Here you can see 2 tracers are not selectable, and then can find
> out how to make them selectable.
> 
> I also add this support for gconfig, but haven't done for xconfig.
> 
> btw: are there many users using gconfig/xconfig today ?

I use xconfig quite a bit, but only use gconfig for making sure that
it still works or displays a menu tree correctly.

---
~Randy
