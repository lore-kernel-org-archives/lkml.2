Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0LCRsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:48:05 -0500
Received: from vostochny.stro.at ([78.47.22.85]:33783 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab0LCRsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:48:03 -0500
Date: Fri, 3 Dec 2010 18:48:00 +0100
From: maximilian attems <max@stro.at>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: support overriding userland architecture
Message-ID: <20101203174800.GA952@stro.at>
Mail-Followup-To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>,
	Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <4CD5A6C8.8030603@asbjorn.biz>
 <1289070320-20726-1-git-send-email-asbjorn@asbjorn.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289070320-20726-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello Asbjoern,

On Sat, 06 Nov 2010, Asbjoern Sloth Toennesen wrote:

> Usefull if building for sparc64 userland, because the
> sparc and sparc64 userlands use the same 64-bit kernel,
> making it impossible to always select the correct userland
> architecture for the resulting debian package.
> 
> Might also be usefull, if you want a i386 userland with a amd64 kernel.
> 
> Example usage:
> 	make DEBARCH=i386 deb-pkg
> 
> This patch is based on my 'kbuild, deb-pkg: select
> userland architecture based on UTS_MACHINE' patch.

care to repost with KBUILD_ prefix, to keep namespace sane and mention
in  Documentation/kbuild/kbuild.txt together with the relevant acks.
It be really cool to have that in next 2.6.38.

thanks
 
> LKML-reference: <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>

Acked-by: maximilian attems <max@stro.at>
