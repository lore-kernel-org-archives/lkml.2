Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1BDBLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 20:11:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33313
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469Ab1BDBLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 20:11:36 -0500
Date: Thu, 03 Feb 2011 17:12:11 -0800 (PST)
Message-Id: <20110203.171211.246535388.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        fweisbec@gmail.com, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH 0/3 v2] [GIT PULL][v2.6.38] tracing: alignment fixes
 (take 3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110203143518.707423251@goodmis.org>
References: <20110203143518.707423251@goodmis.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 03 Feb 2011 09:35:18 -0500

> Ingo,
> 
> The first two patches are the same as before, except that I modified
> the change logs to include David's Acks and to make the updates
> recommended by Mathieu and Thomas Gleixner.
> 
> This also includes a third patch to fix the syscall_metadata.
> I ran all three through the same tests on both x86_64 and x86_32
> with both gcc version 4.5.1 and 4.4.5.
> 
> Please pull the latest tip/perf/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent-2

I did a basic sanity check of this on sparc64 and it looks good.
