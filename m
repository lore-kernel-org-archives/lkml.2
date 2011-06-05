Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab1FEOjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:39:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54086 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1FEOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=v/RIHyWB15HF0A6Wps7SsFyEsTeKp0hWpuePMdGVDxbZ2Cu68yNa2MgZKH5nxDxxqu
         rSGZ0oWaJ3Hf5VR195UTOkY4SSwIrUjKL2DMe9F1NT6CF2mpSKWxmT8TssIydPLRl7PD
         J33OUHFtvg+aH7EVfn453B5KfqWrOGaVe1Jwo=
Date: Sun, 5 Jun 2011 22:38:42 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] MAINTAINERS: Saying goodbye to David Brownell
Message-ID: <20110605143727.GA11961@gmail.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20110605071058.25982.76948.stgit@ponder>
 <20110605003013.9e04ebd0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20110605003013.9e04ebd0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 12:30:13AM -0700, Andrew Morton wrote:
> On Sun, 05 Jun 2011 01:12:03 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > He also leaves behind a number of much loved subsystems now orphaned.
> > This patch updates the MAINTAINERS file for the areas that David was
> > responsible for.  While it removes Davids name from the MAINTAINERS
> > file, it by no mean should be seen as forgetting David's involvement
> > or the work he's accomplished.  Indeed, his name remains prominent
> > in the changelog and copyright notices of many files in the kernel.
> 
> Adding a record to ./CREDITS would be appropriate.  It will be a
> lengthy one.
From: Harry Wei <harryxiyou@gmail.com>

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 CREDITS |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/CREDITS b/CREDITS
index dca6abc..0a248e2 100644
--- a/CREDITS
+++ b/CREDITS
@@ -16,6 +16,10 @@ D: One of assisting postmasters for vger.kernel.org's lists
 S: (ask for current address)
 S: Finland
 
+N: David Brownell
+E: dbrownell@users.sourceforge.net
+D: Maintain drivers/usb/gadget/, include/linux/usb/gadget*
+
 N: Dragos Acostachioaie
 E: dragos@iname.com
 W: http://www.arbornet.org/~dragos
-- 
1.7.0.4

