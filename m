Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0DWU7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:59:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:42212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab0DWU7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:59:53 -0400
Message-ID: <4BD20A4A.7040408@suse.cz>
Date: Fri, 23 Apr 2010 22:59:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Michael Roth <mroth@nessie.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk
Subject: Re: [PATCH] [ARM] .gitignore: Ignore piggy.lzo, lib1funcs.S and vmlinux
References: <1272015498-10749-1-git-send-email-mroth@nessie.de>
In-Reply-To: <1272015498-10749-1-git-send-email-mroth@nessie.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.4.2010 11:38, Michael Roth wrote:
> Commit e7db7b4270ed2a606b8c0b5f944a5f92ade0e84c added LZO compressed
> kernels, lib1funcs.S is copied from the appropriate ARM sub-arch
> and vmlinux is the obvious fruit of all efforts.

vmlinux started to show up in 'git status' after 6db823c, which changed
vmlinux to /vmlinux in the top-level .gitignore.

BTW, there is already *.lzo in the top-level .gitignore in linux-next,
so you could omit piggy.lzo, but anyway

Acked-by: Michal Marek <mmarek@suse.cz>


> Signed-off-by: Michael Roth <mroth@nessie.de>
> ---
>  arch/arm/boot/compressed/.gitignore |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
> index ab204db..6dac3d0 100644
> --- a/arch/arm/boot/compressed/.gitignore
> +++ b/arch/arm/boot/compressed/.gitignore
> @@ -1,3 +1,6 @@
>  font.c
> +lib1funcs.S
>  piggy.gz
> +piggy.lzo
> +vmlinux
>  vmlinux.lds

