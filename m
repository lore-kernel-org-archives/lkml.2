Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0LGWet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:34:49 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:35956 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754226Ab0LGWes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:34:48 -0500
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2010 17:34:47 EST
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201012072219.oB7MJBgm020656@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: fix compiler warning on pnp_ids
To: namhyung@gmail.com (Namhyung Kim)
Date: Wed, 8 Dec 2010 08:49:11 +1030 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
        mjg@redhat.com (Matthew Garrett), platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291734254-12250-1-git-send-email-namhyung@gmail.com> from "Namhyung Kim" at Dec 08, 2010 12:04:14 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me.

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

> Annotate pnp_ids as '__used' to fix following warning:
> 
>   CC      drivers/platform/x86/fujitsu-laptop.o
> drivers/platform/x86/fujitsu-laptop.c:1243: warning: ‘pnp_ids’ defined but not used
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index f44cd26..ad88b2e 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -1240,7 +1240,7 @@ MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
>  MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*");
>  MODULE_ALIAS("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
>  
> -static struct pnp_device_id pnp_ids[] = {
> +static struct pnp_device_id pnp_ids[] __used = {
>  	{.id = "FUJ02bf"},
>  	{.id = "FUJ02B1"},
>  	{.id = "FUJ02E3"},
> -- 
> 1.7.0.4

