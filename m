Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0LIPeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:34:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab0LIPef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:34:35 -0500
Message-ID: <4D00F709.1000406@suse.cz>
Date: Thu, 09 Dec 2010 16:34:33 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH v3] kbuild, deb-pkg: support overriding userland architecture
References: <4D00F473.9090009@asbjorn.biz> <1291908254-19468-1-git-send-email-asbjorn@asbjorn.biz>
In-Reply-To: <1291908254-19468-1-git-send-email-asbjorn@asbjorn.biz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.12.2010 16:24, Asbjoern Sloth Toennesen wrote:
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
> ---
>  Documentation/kbuild/kbuild.txt |    8 ++++++++
>  scripts/package/builddeb        |    3 +++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
> index 634c625..9cf3bf0 100644
> --- a/Documentation/kbuild/kbuild.txt
> +++ b/Documentation/kbuild/kbuild.txt
> @@ -60,6 +60,14 @@ But some architectures such as x86 and sparc have aliases.
>  x86: i386 for 32 bit, x86_64 for 64 bit
>  sparc: sparc for 32 bit, sparc64 for 64 bit
>  
> +KBUILD_DEBARCH
> +--------------------------------------------------
> +For the deb-pkg target, allows overriding the normal heuristics deployed by
> +deb-deb. Normally deb-pkg attempts to guess the right architecture based on
   ^^^^^^^

deb-pkg?

Michal
