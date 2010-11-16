Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab0KPAG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 19:06:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42985 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab0KPAG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 19:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tySZSe4jIO7Ab0Jk6MRIdcM0gKIQirfrrioHVApI5G45m0MF5hPFKouqjvZIcC5Y8r
         j/ckWV5huYUREIFxLAjw==
Date: Mon, 15 Nov 2010 16:06:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jesper Juhl <jj@chaosbits.net>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
Message-ID: <alpine.DEB.2.00.1011151602090.29081@chino.kir.corp.google.com>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com> <20101114181905.bc5b44f9.akpm@linux-foundation.org> <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
 <alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Jesper Juhl wrote:

> [jj@dragon ~]$ uname -a
> Linux dragon 2.6.37-rc1-ARCH-00542-g0143832-dirty #1 SMP PREEMPT Mon Nov 15 22:01:52 CET 2010 x86_64 Intel(R) Core(TM)2 Duo CPU T7250 @ 2.00GHz GenuineIntel GNU/Linux
> [jj@dragon ~]$ dmesg | grep oom_adj
> start_kdeinit (1502): /proc/1502/oom_adj is deprecated, please use /proc/1502/oom_score_adj instead.
> [jj@dragon ~]$ /usr/lib/kde4/libexec/start_kdeinit --version
> 
> Qt: 4.7.1
> KDE: 4.5.3 (KDE 4.5.3)
> 

Thanks for the report!  I'll get involved with kde-devel and send a patch 
to remove this dependency on newer kernels to expedite the process.

 [ Others with reports of deprecated use of oom_adj can contact me 
   privately and I'll find the parties of interest to avoid topics 
   unrelated to the kernel itself on LKML. ]
