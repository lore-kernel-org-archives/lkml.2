Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2DHWj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:39:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35733 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756183Ab2DHWjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:39:15 -0400
Message-ID: <1333924754.2508.11.camel@joe2Laptop>
Subject: Re: [PATCH][Trivial] sound/pci/riptide/riptide.c: remove trailing
 whitespace
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        trivial@kernel.org, Peter Gruber <nokos@gmx.net>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Sun, 08 Apr 2012 15:39:14 -0700
In-Reply-To: <alpine.LNX.2.00.1204090024570.11747@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204090024570.11747@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 00:27 +0200, Jesper Juhl wrote:
> There's a bunch of trailing whitespace at the top of the
> sound/pci/riptide/riptide.c file - this patch gets rid of it.
[]
> diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
[]
> @@ -21,29 +21,29 @@
>  /*
>    History:
>     - 02/15/2004 first release
> -   
> +
>    This Driver is based on the OSS Driver version from Linuxant (riptide-0.6lnxtbeta03111100)
>    credits from the original files:

Might as well delete the whole block.


