Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1H2WH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:07:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:55886 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747Ab1H2WHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:07:55 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan =?utf-8?q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: Re: [PATCH trivial] input: apanel: remove a redundant MODULE_ALIAS
Date: Mon, 29 Aug 2011 15:07:14 -0700
User-Agent: KMail/1.13.7 (Linux/2.6.40.3-0.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Jiri Kosina <trivial@kernel.org>, linux-input@vger.kernel.org,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <1314653189-31020-1-git-send-email-j.neuschaefer@gmx.net>
In-Reply-To: <1314653189-31020-1-git-send-email-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108291507.14497.dmitry.torokhov@gmail.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [140.211.167.34]); Mon, 29 Aug 2011 22:07:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 29, 2011 02:26:29 PM Jonathan Neuschäfer wrote:
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  drivers/input/misc/apanel.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/misc/apanel.c b/drivers/input/misc/apanel.c
> index a8d2b8d..1dd1bd3 100644
> --- a/drivers/input/misc/apanel.c
> +++ b/drivers/input/misc/apanel.c
> @@ -346,5 +346,4 @@ MODULE_DESCRIPTION(APANEL_NAME " driver");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(APANEL_VERSION);
> 
> -MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
>  MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
                                        ^

Not necessarily redundant, if you notice the register is different.

-- 
Dmitry
