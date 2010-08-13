Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551Ab0HMMDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:03:37 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56588 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761520Ab0HMMDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:03:35 -0400
Date: Fri, 13 Aug 2010 14:03:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-git12 fails compile (update_wall_time)
Message-ID: <20100813120332.GA3613@merkur.ravnborg.org>
References: <201008131135.o7DBZYRr018759@clem.clem-digital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008131135.o7DBZYRr018759@clem.clem-digital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 07:35:34AM -0400, Pete Clements wrote:
> Fyi: i386 UP
> 
>   LD      net/netfilter/built-in.o
>   LD      net/built-in.o
>   LD      vmlinux.o
>   MODPOST vmlinux.o
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `update_wall_time':
> (.text+0x2227b): undefined reference to `__umoddi3'
> kernel/built-in.o: In function `update_wall_time':
> (.text+0x2229a): undefined reference to `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1

Please take a lok at the thread named:

    Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0

I think this is the same issue and there is a patch to fix it.

	Sam
