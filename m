Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab2JWUNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:13:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964985Ab2JWUM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:12:58 -0400
Date: Tue, 23 Oct 2012 22:12:55 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 097/193] drivers/net/team: remove CONFIG_EXPERIMENTAL
Message-ID: <20121023201255.GA1667@minipsycho.orion>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-98-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-98-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tue, Oct 23, 2012 at 10:02:50PM CEST, keescook@chromium.org wrote:
>This config item has not carried much meaning for a while now and is
>almost always enabled by default. As agreed during the Linux kernel
>summit, remove it.
>
>CC: Jiri Pirko <jpirko@redhat.com>

I wanted to do this anyway.

Acked-by: Jiri Pirko <jpirko@redhat.com>


>Signed-off-by: Kees Cook <keescook@chromium.org>
>---
> drivers/net/team/Kconfig |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/drivers/net/team/Kconfig b/drivers/net/team/Kconfig
>index 6b08bd4..c3011af 100644
>--- a/drivers/net/team/Kconfig
>+++ b/drivers/net/team/Kconfig
>@@ -1,6 +1,5 @@
> menuconfig NET_TEAM
>-	tristate "Ethernet team driver support (EXPERIMENTAL)"
>-	depends on EXPERIMENTAL
>+	tristate "Ethernet team driver support"
> 	---help---
> 	  This allows one to create virtual interfaces that teams together
> 	  multiple ethernet devices.
>-- 
>1.7.9.5
>
