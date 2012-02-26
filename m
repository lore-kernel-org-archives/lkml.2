Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2BZOgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 09:36:09 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:11392 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab2BZOgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 09:36:08 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Feb 2012 09:36:08 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicFAKU/KE8YNOMa/2dsb2JhbACBX5x7eaB5hFo3f4YZBIZQiUGEL4pk
X-IronPort-AV: E=Sophos;i="4.73,1,1325480400"; 
   d="scan'208";a="164724433"
Message-ID: <4F4A412F.6010000@gmail.com>
Date: Sun, 26 Feb 2012 09:26:55 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Firefox/10.0.2 SeaMonkey/2.7.2
MIME-Version: 1.0
To: "Tomas M." <tmezzadra@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux 3.3-rc5 fails to build
References: <4F4A23EC.2040802@gmail.com>
In-Reply-To: <4F4A23EC.2040802@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas M. wrote:
> Hi everyone,
>
> autofs4 breaks build in 3.3-rc5
>
> ---
> CC fs/ioprio.o
> CC fs/proc_namespace.o
> CC [M] fs/autofs4/init.o
> CC [M] fs/autofs4/inode.o
> fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
> fs/autofs4/inode.c:228:2: error: implicit declaration of function 
> ‘is_compat_task’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
>
> make[2]: *** [fs/autofs4/inode.o] Error 1
> make[1]: *** [fs/autofs4] Error 2
> make: *** [fs] Error 2
>
>
> could it be commit a32744d4abae24572eff7269bc17895c41bd0085
>
> autofs: work around unhappy compat problem on x86-64
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Same error here.
Woody

