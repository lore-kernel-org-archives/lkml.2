Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0KYOf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:35:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:53878 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab0KYOfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:35:54 -0500
Date: Thu, 25 Nov 2010 15:35:53 +0100
From: Michal Marek <mmarek@suse.cz>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: select userland architecture based on
 UTS_MACHINE
Message-ID: <20101125143553.GB8192@sepie.suse.cz>
References: <4CD406C7.8090801@asbjorn.biz>
 <1288963808-7057-1-git-send-email-asbjorn@asbjorn.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288963808-7057-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 01:30:08PM +0000, Asbjoern Sloth Toennesen wrote:
> Instead of creating the debian package for the compiling userland,
> create it for a userland matching the kernel thats being compiled.
> 
> This patch supports all Lenny release architectures,
> and Linux-based architecture candidates for Squeeze.
> 
> If it can't find a proper Debian userspace it displays a warning,
> and fallback to let deb-gencontrol use the host's userspace arch.
> 
> Eg. with this patch the following make command:
> 
> 	make ARCH=i386 deb-pkg
> 
> will output an i386 Debian package instead of an amd64 one,
> when run on an amd64 machine.
> 
> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
> ---
>  scripts/package/builddeb |   35 ++++++++++++++++++++++++++++++++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)

Applied to kbuild-2.6.git#packaging, thanks.

Michal
