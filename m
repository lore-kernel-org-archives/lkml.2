Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1JZT5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:57:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:46695 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1JZT5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:57:48 -0400
Message-ID: <4EA86636.9010009@windriver.com>
Date: Wed, 26 Oct 2011 15:57:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the moduleh tree with the  tree
References: <20111025194519.de13df739f60f9d961425558@canb.auug.org.au>
In-Reply-To: <20111025194519.de13df739f60f9d961425558@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-10-25 04:45 AM, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the moduleh tree got a conflict in
> arch/arm/plat-s5p/dev-tv.c from merge fix patch
> "arm-Add-export.h-to-recently-added-files-for-EXPORT_.patch" from the
> moduleh tree.
> 
> This file has been removed, so I dropped that hunk.

Hi Stephen,

I'm surprised to see this, since I'd dropped this chunk based on
the last linux-next build you did before leaving for vacation.
You should see this commit in the merge fix repo.

~$git ls-remote git://openlinux.windriver.com/people/paulg/modsplit-post-merge
edaec64f302889b6f6eaf2d206782f46768d9922	HEAD
edaec64f302889b6f6eaf2d206782f46768d9922	refs/heads/master
~$

Maybe the server fell over again when you were trying to update?

Thanks,
Paul.

---

commit edaec64f302889b6f6eaf2d206782f46768d9922
Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Thu Oct 13 22:25:20 2011 -0400

    drop dev-tv chunk from arm fixup patch
    
    Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arm-Add-export.h-to-recently-added-files-for-EXPORT_.patch b/arm-Ad
index 9e1cbbb..89e71ed 100644
--- a/arm-Add-export.h-to-recently-added-files-for-EXPORT_.patch
+++ b/arm-Add-export.h-to-recently-added-files-for-EXPORT_.patch
@@ -10,18 +10,6 @@ new export.h file included that provides them.
 
 Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
 
-diff --git a/arch/arm/plat-s5p/dev-tv.c b/arch/arm/plat-s5p/dev-tv.c
-index 361a1b6..7c5fb88 100644
---- a/arch/arm/plat-s5p/dev-tv.c
-+++ b/arch/arm/plat-s5p/dev-tv.c
-@@ -11,6 +11,7 @@
- */
- 
- #include <linux/dma-mapping.h>
-+#include <linux/export.h>
- 
- #include <mach/irqs.h>
- #include <mach/map.h>
 diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
 index 6e3d9ab..93a994a 100644
 --- a/arch/arm/plat-samsung/dma-ops.c
