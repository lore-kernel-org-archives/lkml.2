Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab1INUXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:23:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:38298 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142Ab1INUXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:23:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48481992"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, jbottomley@parallels.com
Subject: Re: [PATCH 0/9] Per-cgroup /proc/stat
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	<1316031196.5040.46.camel@twins>
Date: Wed, 14 Sep 2011 13:23:14 -0700
In-Reply-To: <1316031196.5040.46.camel@twins> (Peter Zijlstra's message of
	"Wed, 14 Sep 2011 22:13:16 +0200")
Message-ID: <m2fwjyg9fx.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
>
> Guys we should seriously trim back a lot of that code, not grow ever
> more and more. The sad fact is that if you build a kernel with
> cpu-cgroup support the context switch cost is more than double that of a
> kernel without, and then you haven't even started creating cgroups yet.

That sounds indeed quite bad. Is it known why it is so costly?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
