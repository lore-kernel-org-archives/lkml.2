Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab2CWTsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:48:33 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49442 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754325Ab2CWTsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:48:32 -0400
Message-ID: <4F6CD38B.1010602@xenotime.net>
Date: Fri, 23 Mar 2012 12:48:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig: Update defconfigs
References: <tip-ahz3d8i1vxwj0379gv4tqcru@git.kernel.org>
In-Reply-To: <tip-ahz3d8i1vxwj0379gv4tqcru@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 12:43 PM, tip-bot for Ingo Molnar wrote:

> Commit-ID:  280fb016bfb098f33df96016cfaa840db77ba2d0
> Gitweb:     http://git.kernel.org/tip/280fb016bfb098f33df96016cfaa840db77ba2d0
> Author:     Ingo Molnar <mingo@kernel.org>
> AuthorDate: Fri, 23 Mar 2012 13:12:38 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 23 Mar 2012 13:14:53 +0100
> 
> x86/kconfig: Update defconfigs
> 
> Link: http://lkml.kernel.org/n/tip-ahz3d8i1vxwj0379gv4tqcru@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/configs/i386_defconfig   |   65 ++++++++++++-----------------------
>  arch/x86/configs/x86_64_defconfig |   68 +++++++++++++------------------------
>  2 files changed, 47 insertions(+), 86 deletions(-)
> 
> diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
> index 2bf18059f..2d56282 100644
> --- a/arch/x86/configs/i386_defconfig
> +++ b/arch/x86/configs/i386_defconfig
> -CONFIG_TR=y
> +CONFIG_TR=y



> diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
> index 058a35b..3cf137a 100644
> --- a/arch/x86/configs/x86_64_defconfig
> +++ b/arch/x86/configs/x86_64_defconfig
> -CONFIG_TR=y
> +CONFIG_TR=y


Hmph.  On 2009-oct-20, I sent a patch to disable CONFIG_TR
from these defconfigs.  I still think that should be done.

-- 
~Randy
