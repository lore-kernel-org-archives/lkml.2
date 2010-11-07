Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab0KGIWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 03:22:52 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55505 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0KGIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 03:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rXCV727Yz0vlSdVUHkYLa/5NwTWQIMEfA/Ji0N50pp5FVtHSKZissIQ6HYVZ0K/tu7
         twSUI5z83a0DVrCXXyZYNuUcDTJyM76toMr2tA+gZGdFrpzGAyEf2ECNr+kZq3J4OQ5C
         2wU+tFqeP/k7AIni4a6gmYRZN6f6srUQw7P5s=
Date: Sun, 7 Nov 2010 16:24:07 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: support overriding userland
	architecture
Message-ID: <20101107082407.GO3046@hack>
References: <4CD5A6C8.8030603@asbjorn.biz> <1289070320-20726-1-git-send-email-asbjorn@asbjorn.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289070320-20726-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 07:05:20PM +0000, Asbjoern Sloth Toennesen wrote:
>Usefull if building for sparc64 userland, because the
>sparc and sparc64 userlands use the same 64-bit kernel,
>making it impossible to always select the correct userland
>architecture for the resulting debian package.
>
>Might also be usefull, if you want a i386 userland with a amd64 kernel.
>
>Example usage:
>	make DEBARCH=i386 deb-pkg
>
>This patch is based on my 'kbuild, deb-pkg: select
>userland architecture based on UTS_MACHINE' patch.
>

This is a good idea. :)

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

-- 
Live like a child, think like the god.
 
