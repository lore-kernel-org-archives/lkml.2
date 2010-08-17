Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0HQFfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:35:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54639 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab0HQFfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=R1879md/8BNKRCwIUegIelzkmC0dtXXUzJj7b0ykEfZxMA7fT060rlc9L/djwBya4m
         s2SYvitKyX1CFwY+aoBd3XHXKSkvRetx3jz7ruJxJkMgcYJjzuhM7vv3U/YLqBQKxE5V
         z8y+Kk6tv/Qg1LyypgDmcw1DbI659mSUSBYYI=
Date: Tue, 17 Aug 2010 13:40:00 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?B?w4Z2YXIgQXJuZmrDtnLDsA==?= Bjarmason <avar@v.nix.is>
Cc: torvalds@linux-foundation.org,
        David Woodhouse <dwmw2@tylersburg.infradead.org>,
        Linux is full of bugs <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] .gitignore: Ignore generated files in lib/raid6
Message-ID: <20100817054000.GB5095@cr0.nay.redhat.com>
References: <1282019131-30813-1-git-send-email-avar@v.nix.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1282019131-30813-1-git-send-email-avar@v.nix.is>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 04:25:31AM +0000, Ævar Arnfjörð Bjarmason wrote:
>The Makefile in lib/raid6 will generate these files, and the clean
>target will remove them, but they weren't being ignored by git.
>
>Signed-off-by: Ævar Arnfjörð Bjarmason <avar@v.nix.is>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

>---
> lib/raid6/.gitignore |   16 ++++++++++++++++
> 1 files changed, 16 insertions(+), 0 deletions(-)
> create mode 100644 lib/raid6/.gitignore
>
>diff --git a/lib/raid6/.gitignore b/lib/raid6/.gitignore
>new file mode 100644
>index 0000000..ce56377
>--- /dev/null
>+++ b/lib/raid6/.gitignore
>@@ -0,0 +1,16 @@
>+#
>+# Generated files
>+#
>+
>+altivec1.c
>+altivec2.c
>+altivec4.c
>+altivec8.c
>+int1.c
>+int16.c
>+int2.c
>+int32.c
>+int4.c
>+int8.c
>+mktables
>+tables.c
>-- 
>1.7.2.1.389.gc3d0b
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
