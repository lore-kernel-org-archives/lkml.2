Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2APAUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:20:19 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45136 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2APAUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:20:17 -0500
X-AuditID: b753bd60-9825fba00000359c-10-4f136d3d0eeb
X-AuditID: b753bd60-9825fba00000359c-10-4f136d3d0eeb
Message-ID: <4F136D22.5050005@hitachi.com>
Date: Mon, 16 Jan 2012 09:19:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        pp-manager@sdl.hitachi.co.jp
Subject: Re: [Patch] x86: add arch/x86/tools/insn_sanity to .gitignore
References: <1326628937-27609-1-git-send-email-xiyou.wangcong@gmail.com>
In-Reply-To: <1326628937-27609-1-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/15 21:02), xiyou.wangcong@gmail.com wrote:
> After compiling kernel, I got:
> 
> 	% git status
> 	# On branch master
> 	# Untracked files:
> 	#   (use "git add <file>..." to include in what will be committed)
> 	#
> 	#	arch/x86/tools/insn_sanity
> 	nothing added to commit but untracked files present (use "git add" to track)
> 
> it should be added to .gitignore.

Right! Thank you for fixing!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> diff --git a/arch/x86/.gitignore b/arch/x86/.gitignore
> index 0280790..7cab8c0 100644
> --- a/arch/x86/.gitignore
> +++ b/arch/x86/.gitignore
> @@ -1,3 +1,4 @@
>  boot/compressed/vmlinux
>  tools/test_get_len
> +tools/insn_sanity
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
