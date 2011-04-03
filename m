Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1DCEw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 00:52:58 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56474 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1DCEw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 00:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=A7ZwXzwkFEz1zT9BL4hd1mZTbUWDkGP8A2TITv8PpIW3MB/C9hDEPXfgTFgkWLD1HQ
         RcnuBRMyGvYqdIGlNCtXwjpXPitcOz++XS9glYfljLbjHmMiEuNSJqdo26qWZr1h93se
         u0RzIKmhoiiBdOqlO54oLd/daQL+aFkllfbww=
Date: Sun, 3 Apr 2011 12:52:15 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Someone Something <fordhaivat@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        joe@perches.com, akpm@linux-foundation.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Fixes a small error in Documentation/HOWTO
Message-ID: <20110403045201.GA2598@gmail.com>
Mail-Followup-To: Someone Something <fordhaivat@gmail.com>, greg@kroah.com,
	linux-kernel@vger.kernel.org, rdunlap@xenotime.net, joe@perches.com,
	akpm@linux-foundation.org, linux-doc@vger.kernel.org
References: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 03:03:43PM -0500, Someone Something wrote:
> Description: This patch fixes a small error in Documentation/HOWTO
> which gives a really old link for LXR.
> 
> This will be my first patch, so, any feedback is very welcome The
> Patch follows this line. I'm not sure if I'm supposed to include the
> HOWTO.orig stuff.
> 
> 
> --- linux-2.6.38.2/Documentation/HOWTO.orig     2011-04-02
> 15:55:03.000000000 -0400
> +++ linux-2.6.38.2/Documentation/HOWTO  2011-04-02 15:56:25.000000000 -0400
> @@ -209,8 +209,7 @@ tools.  One such tool that is particular
>  Cross-Reference project, which is able to present source code in a
>  self-referential, indexed webpage format. An excellent up-to-date
>  repository of the kernel code may be found at:
> -       http://users.sosdg.org/~qiyong/lxr/
> -
> +       http://lxr.linux.no/linux+v2.6.38/Documentation/
>
Your updated link for HOWTO is just for linux-2.6.38. This link
should be up-to-date kernel code. So i have corrected your
patch like following.

Thanks.
Best Regards.
Harry Wei.

Signed-off-by: Someone Something <fordhaivat@gmail.com>
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

