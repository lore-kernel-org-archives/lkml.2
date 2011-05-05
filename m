Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab1EEX4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 19:56:06 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:58048 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1EEX4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 19:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mUrQlDcSMwyvgJXpCyZvw6lySiNVdlOtquwfPJGcgFmLSb1rSvCfvycSf3wPZz2hOp
         jScNbS0t6uTDTwQKb6lV0a5pXATBS9q6HTjyqA09Nm362yAisgLr3Ss7LialXPjm+lSX
         ykTI++nBVAct96puNujTF2FwFCK1xt6TR25V8=
Date: Fri, 6 May 2011 07:55:51 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fixes a small error in Documentation/HOWTO
Message-ID: <20110505235548.GA2075@gmail.com>
Mail-Followup-To: Randy Dunlap <rdunlap@xenotime.net>,
	linux-kernel@vger.kernel.org, greg@kroah.com,
	akpm@linux-foundation.org
References: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
 <20110403045201.GA2598@gmail.com>
 <4D99230C.6040403@cn.fujitsu.com>
 <20110404111829.af8bc108.rdunlap@xenotime.net>
 <BANLkTinSC1UTEQxS0iCKu4tMX-9CUY3rJg@mail.gmail.com>
 <20110405020717.GA2506@gmail.com>
 <20110505150719.f4d480ad.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20110505150719.f4d480ad.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 03:07:19PM -0700, Randy Dunlap wrote:
> 
> Linus tells me that we don't want fake names or email addresses in
> the development tree, so this won't do.
> 
> Harry, can you just send me a patch from you, with your Signed-off-by:
> so that I can apply it, please?
Hi Randy,
	My pleasure, the patch is below. If you have any other questions,
please let me know.

Thanks.
Harry Wei.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 Documentation/HOWTO |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 365bda9..81bc1a9 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -209,7 +209,7 @@ tools.  One such tool that is particularly recommended is the Linux
 Cross-Reference project, which is able to present source code in a
 self-referential, indexed webpage format. An excellent up-to-date
 repository of the kernel code may be found at:
-	http://users.sosdg.org/~qiyong/lxr/
+	http://lxr.linux.no/+trees
 
 
 The development process
-- 
1.7.0.4

