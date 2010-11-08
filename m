Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0KHPTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:19:37 -0500
Received: from baron.coraid.com ([12.51.113.4]:58056 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752106Ab0KHPTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:19:36 -0500
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2010 10:19:36 EST
Subject: Re: [Resend][PATCH 2/2] Drivers: block: aoe: Makefile: replace the use of <module>-objs with <module>-y
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <1289069918-2085-2-git-send-email-tdent48227@gmail.com>
Date: Mon, 8 Nov 2010 10:03:24 -0500
Cc: sage@newdream.net, yehuda@hq.newdream.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <EDA33B3B-F9C9-4C45-B20D-C985DFC95C2F@coraid.com>
References: <1289069918-2085-1-git-send-email-tdent48227@gmail.com> <1289069918-2085-2-git-send-email-tdent48227@gmail.com>
To: akpm@linux-foundation.org
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2010, at 2:58 PM, Tracey Dent wrote:

> Changed <module>-objs to <module>-y in Makefile.

Andrew Morton, hi.  I don't know whether Tracey Dent is expecting
me to push this change to Linus, but lately you've been pushing the
aoe changes.  I see similar changes in other
drivers on the LKML, so if it looks good to you, would you mind please
picking up this patch?

> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
> drivers/block/aoe/Makefile |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/aoe/Makefile b/drivers/block/aoe/Makefile
> index e76d997..06ea82c 100644
> --- a/drivers/block/aoe/Makefile
> +++ b/drivers/block/aoe/Makefile
> @@ -3,4 +3,4 @@
> #
> 
> obj-$(CONFIG_ATA_OVER_ETH)	+= aoe.o
> -aoe-objs := aoeblk.o aoechr.o aoecmd.o aoedev.o aoemain.o aoenet.o
> +aoe-y := aoeblk.o aoechr.o aoecmd.o aoedev.o aoemain.o aoenet.o
> -- 
> 1.7.3.2.146.gca209
> 

-- 
  Ed Cashin
  ecashin@coraid.com

