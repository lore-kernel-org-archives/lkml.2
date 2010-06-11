Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab0FKUHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:07:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:41318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab0FKUH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:07:28 -0400
Message-ID: <4C129778.7040409@suse.cz>
Date: Fri, 11 Jun 2010 22:07:20 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Takeo Tung <kernel@takeo.idv.tw>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next-20100608 will /bin/sh: scripts/basic/fixdep: Permission
 denied
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1>
In-Reply-To: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.6.2010 17:13, Takeo Tung wrote:
> Dear All,
> 
> I using linux-next-20100608 kernel, but if re-complier the kernel will
> found
> this messages.
> 
> root@kernel-x86:/usr/src/linux# make oldconfig
>  HOSTCC  scripts/basic/fixdep
> /bin/sh: scripts/basic/fixdep: Permission denied
> make[1]: *** [scripts/basic/fixdep] Error 1
> make: *** [scripts_basic] Error 2
> 
> But if I revert this patch, seems all back to normal, pls help me this is
> bug patch or need adjust some system config?
> 
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=9d9b938248736826e86db9b16a3b435bdb5d649f

Do I understand it correctly that you can't rebuild your kernel if
you're running linux-next-20100608 and that the problem goes away if you
revert the above patch, recompile somewhere else and boot the new
kernel? I.e. it's unlikely a problem with fixdep itself?

Adding Christoph Hellwig to cc.

Michal
