Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2HDBRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 21:17:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab2HDBRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 21:17:45 -0400
Date: Fri, 3 Aug 2012 18:15:31 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH] pstore: fix printk format warning
Message-ID: <20120804011531.GA22175@lizard>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
 <501C66A8.5000902@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <501C66A8.5000902@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 05:02:48PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warning (on i386) in pstore:
> 
> fs/pstore/ram.c:409:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
> I posted this patch on June 15 and July 23 but it has not been
> merged anywhere afaict, so I'm sending it directly to the man.

(I believe it's the first time I see that patch.)

Btw, I see no maintainers for the pstore, and it surely no longer
belongs to staging. Tony, I can send patches to you, or I can create
a git tree (actually, I already had it for my own convenience).. So
how about the following patch?

Kees, Colin, as you're also pstore authors, I assume you're interested
in reviewing/[n]acking any possible changes, so I also added you to
the M: entries, is that OK?

- - - -
From: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH] MAINTAINERS: Add pstore maintainers


Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 94b823f..9aa40c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5496,6 +5496,18 @@ L:	cbe-oss-dev@lists.ozlabs.org
 S:	Maintained
 F:	drivers/block/ps3vram.c
 
+PSTORE FILESYSTEM
+M:	Anton Vorontsov <cbouatmailru@gmail.com>
+M:	Colin Cross <ccross@android.com>
+M:	Kees Cook <keescook@chromium.org>
+M:	Tony Luck <tony.luck@intel.com>
+S:	Maintained
+T:	git git://git.infradead.org/users/cbou/linux-pstore.git
+F:	fs/pstore/
+F:	include/linux/pstore*
+F:	drivers/firmware/efivars.c
+F:	drivers/acpi/apei/erst.c
+
 PTP HARDWARE CLOCK SUPPORT
 M:	Richard Cochran <richardcochran@gmail.com>
 S:	Maintained
-- 
1.7.10.4

