Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0KYOhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:37:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:53915 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab0KYOhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:37:40 -0500
Date: Thu, 25 Nov 2010 15:37:39 +0100
From: Michal Marek <mmarek@suse.cz>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: support overriding userland architecture
Message-ID: <20101125143739.GC8192@sepie.suse.cz>
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

On Sat, Nov 06, 2010 at 07:05:20PM +0000, Asbjoern Sloth Toennesen wrote:
> Usefull if building for sparc64 userland, because the
> sparc and sparc64 userlands use the same 64-bit kernel,
> making it impossible to always select the correct userland
> architecture for the resulting debian package.
> 
> Might also be usefull, if you want a i386 userland with a amd64 kernel.
> 
> Example usage:
> 	make DEBARCH=i386 deb-pkg

This variable deserves a mention in Documentation/kbuild/kbuild.txt not
just in the commit log. Otherwise the patch is OK with me.  

Michal
