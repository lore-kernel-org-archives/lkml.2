Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab0I1HR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:17:28 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:54268 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756891Ab0I1HR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:17:27 -0400
Date: Tue, 28 Sep 2010 00:16:06 -0700
From: matt mooney <mfm@muteddisk.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 08/20] m68knommu: change to new flag variables
Message-ID: <20100928071606.GA13303@haskell.muteddisk.com>
Mail-Followup-To: Greg Ungerer <gerg@snapgear.com>,
	Greg Ungerer <gerg@uclinux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <1285224645-29728-1-git-send-email-mfm@muteddisk.com>
 <4CA18E00.7090207@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA18E00.7090207@snapgear.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:41 Tue 28 Sep     , Greg Ungerer wrote:
> 
> Hi Matt,
> 
> On 23/09/10 16:50, matt mooney wrote:
> >Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.
> >
> >Signed-off-by: matt mooney<mfm@muteddisk.com>
> 
> Looks fine to me. Are you looking for this to go through
> maintainer trees, or the whole patch series in one go?

Hi Greg,

My original intent was through the maintainer trees; however, I am starting to
realize that it probably would have been best to all go into the kbuild tree as
one patch series. That being said, some people have picked them up and others
have just acked, so really whatever is easiest for you. All unapplied will
eventually go through the kbuild tree.

Thanks,
mfm

> Acked-by: Greg Ungerer <gerg@uclinux.org>
> 
> Regards
> Greg
> 
> 
> >---
> >  arch/m68knommu/platform/5206/Makefile     |    4 ++--
> >  arch/m68knommu/platform/5206e/Makefile    |    4 ++--
> >  arch/m68knommu/platform/520x/Makefile     |    4 ++--
> >  arch/m68knommu/platform/523x/Makefile     |    4 ++--
> >  arch/m68knommu/platform/5249/Makefile     |    4 ++--
> >  arch/m68knommu/platform/5272/Makefile     |    4 ++--
> >  arch/m68knommu/platform/527x/Makefile     |    4 ++--
> >  arch/m68knommu/platform/528x/Makefile     |    4 ++--
> >  arch/m68knommu/platform/5307/Makefile     |    4 ++--
> >  arch/m68knommu/platform/532x/Makefile     |    4 ++--
> >  arch/m68knommu/platform/5407/Makefile     |    4 ++--
> >  arch/m68knommu/platform/coldfire/Makefile |    4 ++--
> >  12 files changed, 24 insertions(+), 24 deletions(-)
> >
> >diff --git a/arch/m68knommu/platform/5206/Makefile b/arch/m68knommu/platform/5206/Makefile
> >index 113c333..b5db056 100644
> >--- a/arch/m68knommu/platform/5206/Makefile
> >+++ b/arch/m68knommu/platform/5206/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs.  You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/5206e/Makefile b/arch/m68knommu/platform/5206e/Makefile
> >index 113c333..b5db056 100644
> >--- a/arch/m68knommu/platform/5206e/Makefile
> >+++ b/arch/m68knommu/platform/5206e/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs.  You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/520x/Makefile b/arch/m68knommu/platform/520x/Makefile
> >index 435ab34..ad3f4e5 100644
> >--- a/arch/m68knommu/platform/520x/Makefile
> >+++ b/arch/m68knommu/platform/520x/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs.  You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/523x/Makefile b/arch/m68knommu/platform/523x/Makefile
> >index b8f9b45..c04b8f7 100644
> >--- a/arch/m68knommu/platform/523x/Makefile
> >+++ b/arch/m68knommu/platform/523x/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs.  You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/5249/Makefile b/arch/m68knommu/platform/5249/Makefile
> >index f56225d..4bed30f 100644
> >--- a/arch/m68knommu/platform/5249/Makefile
> >+++ b/arch/m68knommu/platform/5249/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs.  You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/5272/Makefile b/arch/m68knommu/platform/5272/Makefile
> >index 93673ef..34110fc 100644
> >--- a/arch/m68knommu/platform/5272/Makefile
> >+++ b/arch/m68knommu/platform/5272/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs.  You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/527x/Makefile b/arch/m68knommu/platform/527x/Makefile
> >index 3d90e6d..6ac4b57 100644
> >--- a/arch/m68knommu/platform/527x/Makefile
> >+++ b/arch/m68knommu/platform/527x/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs.  You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/528x/Makefile b/arch/m68knommu/platform/528x/Makefile
> >index 3d90e6d..6ac4b57 100644
> >--- a/arch/m68knommu/platform/528x/Makefile
> >+++ b/arch/m68knommu/platform/528x/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs.  You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/5307/Makefile b/arch/m68knommu/platform/5307/Makefile
> >index 6de5269..d4293b7 100644
> >--- a/arch/m68knommu/platform/5307/Makefile
> >+++ b/arch/m68knommu/platform/5307/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs. You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/532x/Makefile b/arch/m68knommu/platform/532x/Makefile
> >index 4cc2324..ce01669 100644
> >--- a/arch/m68knommu/platform/532x/Makefile
> >+++ b/arch/m68knommu/platform/532x/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs. You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/5407/Makefile b/arch/m68knommu/platform/5407/Makefile
> >index dee62c5..e83fe14 100644
> >--- a/arch/m68knommu/platform/5407/Makefile
> >+++ b/arch/m68knommu/platform/5407/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs. You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> >diff --git a/arch/m68knommu/platform/coldfire/Makefile b/arch/m68knommu/platform/coldfire/Makefile
> >index f72a0e5..788c13f 100644
> >--- a/arch/m68knommu/platform/coldfire/Makefile
> >+++ b/arch/m68knommu/platform/coldfire/Makefile
> >@@ -8,8 +8,8 @@
> >  # on the console port whenever a DBG interrupt occurs. You have to
> >  # set up you HW breakpoints to trigger a DBG interrupt:
> >  #
> >-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> >-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> >+# ccflags-y := -DTRAP_DBG_INTERRUPT
> >+# asflags-y := -DTRAP_DBG_INTERRUPT
> >  #
> >
> >  asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> 
