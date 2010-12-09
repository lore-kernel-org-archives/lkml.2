Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0LIOYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 09:24:50 -0500
Received: from vostochny.stro.at ([78.47.22.85]:40309 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0LIOYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 09:24:48 -0500
Date: Thu, 9 Dec 2010 14:24:47 +0000
From: maximilian attems <max@stro.at>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH v2] kbuild, deb-pkg: support overriding userland
	architecture
Message-ID: <20101209142447.GA12350@vostochny.stro.at>
References: <20101125143739.GC8192@sepie.suse.cz> <1291844150-4541-1-git-send-email-asbjorn@asbjorn.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291844150-4541-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 09:35:50PM +0000, Asbjoern Sloth Toennesen wrote:
> Usefull if building for sparc64 userland, because the
> sparc and sparc64 userlands use the same 64-bit kernel,
> making it impossible to always select the correct userland
> architecture for the resulting debian package.
> 
> Might also be usefull, if you want a i386 userland with a amd64 kernel.
> 
> Example usage:
> 	make DEBARCH=i386 deb-pkg

hmm the conclusion was to prepend a KBUILD_ prefix for a kbuild variable?
Any reason why that was overlooked?

I checked man devscripts and saw yet no definition of DEBARCH, but in order
not to have any potential conflicts and to keep namespase sane I think
it is very much preferred to use KBUILD_DEBARCH.

thanks

-- 
maks
