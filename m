Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0LTPx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:53:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab0LTPx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:53:57 -0500
Date: Mon, 20 Dec 2010 16:53:56 +0100
From: Michal Marek <mmarek@suse.cz>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH v4] kbuild, deb-pkg: support overriding userland
 architecture
Message-ID: <20101220155356.GE20492@sepie.suse.cz>
References: <4D00F709.1000406@suse.cz>
 <1292175580-22085-1-git-send-email-asbjorn@asbjorn.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292175580-22085-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 05:39:40PM +0000, Asbjoern Sloth Toennesen wrote:
> Usefull if building for sparc64 userland, because the
> sparc and sparc64 userlands use the same 64-bit kernel,
> making it impossible to always select the correct userland
> architecture for the resulting debian package.
> 
> Might also be usefull, if you want a i386 userland with a amd64 kernel.
> 
> Example usage:
> 	make KBUILD_DEBARCH=i386 deb-pkg
> 
> LKML-reference: <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
> Acked-by: maximilian attems <max@stro.at>

Applied to kbuild-2.6.git#packaging, thanks.

Michal
