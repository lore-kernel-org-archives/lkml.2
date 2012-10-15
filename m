Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2JOVyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:54:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39438 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2JOVyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:54:15 -0400
Date: Mon, 15 Oct 2012 23:54:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/version.h: Update for kernel 3.7
Message-ID: <20121015215411.GB28086@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <507c837f.D1Nk8uFiYhA4dhxy%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <507c837f.D1Nk8uFiYhA4dhxy%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 04:43:27PM -0500, Larry Finger wrote:
> The value for LINUX_VERSION_CODE was not updated for kernel 3.7-rc1.

That's probably fallout from the whole UAPI thing.

> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  version.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> ---
> 
> Index: linux-2.6/include/linux/version.h
> ===================================================================
> --- linux-2.6.orig/include/linux/version.h
> +++ linux-2.6/include/linux/version.h
> @@ -1,2 +1,2 @@

There are two version.h files on my box:

> -#define LINUX_VERSION_CODE 198144

This is in <include/linux/version.h>

> +#define LINUX_VERSION_CODE 198400

This is in <include/generated/uapi/linux/version.h>

I'd guess that everything should include this new version.h file now
since the Makefile generates this now and not the one above.

But I could very well be wrong.

-- 
Regards/Gruss,
    Boris.
