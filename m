Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2FOTce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:32:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53140 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab2FOTcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:32:32 -0400
MIME-Version: 1.0
In-Reply-To: <4FDB8AB8.6060703@xenotime.net>
References: <20120615143303.3b88edcbc3efc7b1bf81839b@canb.auug.org.au>
	<4FDB8AB8.6060703@xenotime.net>
Date: Fri, 15 Jun 2012 12:32:30 -0700
X-Google-Sender-Auth: 43fgD2aGzG9QC6wlszxfRVBiZPY
Message-ID: <CAGXu5j+VixgdQgvxkM1SHOC_vSwD0jwSdY36vG1n+d8VE0_7EQ@mail.gmail.com>
Subject: Re: [PATCH -next] pstore: fix printk format warning in ram.c
From: Kees Cook <keescook@chromium.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 12:19 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix printk format warning (on i386) in pstore:
>
> fs/pstore/ram.c:378:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

I thought Greg already pulled this into his tree? Regardless:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
