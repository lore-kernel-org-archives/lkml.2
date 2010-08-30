Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0H3IJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:09:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:54076 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab0H3IJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:09:44 -0400
Date: Mon, 30 Aug 2010 18:09:34 +1000
From: Neil Brown <neilb@suse.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/raid6: ignore generated files
Message-ID: <20100830180934.2dd88033@notabene>
In-Reply-To: <m2d3t9z1f9.fsf@igel.home>
References: <m2d3t9z1f9.fsf@igel.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 19:25:30 +0200
Andreas Schwab <schwab@linux-m68k.org> wrote:

> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
>  lib/raid6/.gitignore |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>  create mode 100644 lib/raid6/.gitignore
> 
> diff --git a/lib/raid6/.gitignore b/lib/raid6/.gitignore
> new file mode 100644
> index 0000000..730e5ec
> --- /dev/null
> +++ b/lib/raid6/.gitignore
> @@ -0,0 +1,12 @@
> +int1.c
> +int2.c
> +int4.c
> +int8.c
> +int16.c
> +int32.c
> +altivec1.c
> +altivec2.c
> +altivec4.c
> +altivec8.c
> +tables.c
> +mktables

Thanks.  I've queued a slightly different patch for Linus.

NeilBrown

commit 7c44ece988a3419e51c833cf14be186a22224dd1
Author: NeilBrown <neilb@suse.de>
Date:   Mon Aug 30 17:35:52 2010 +1000

    Move .gitignore from drivers/md to lib/raid6
    
    Another missing bit of the raid6 -> /lib move.
    
    Reported-by: Andreas Schwab <schwab@linux-m68k.org>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/.gitignore b/drivers/md/.gitignore
deleted file mode 100644
index a7afec6..0000000
--- a/drivers/md/.gitignore
+++ /dev/null
@@ -1,4 +0,0 @@
-mktables
-raid6altivec*.c
-raid6int*.c
-raid6tables.c
diff --git a/lib/raid6/.gitignore b/lib/raid6/.gitignore
new file mode 100644
index 0000000..162beca
--- /dev/null
+++ b/lib/raid6/.gitignore
@@ -0,0 +1,4 @@
+mktables
+altivec*.c
+int*.c
+tables.c

