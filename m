Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0CUUMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:12:30 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44021 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753397Ab0CUUM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:12:28 -0400
Date: Sun, 21 Mar 2010 21:12:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: sme_api.h Coding style fixes.
Message-ID: <20100321201221.GI1933@elf.ucw.cz>
References: <1269190503-12050-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269190503-12050-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-21 17:55:03, Lars Lindley wrote:
> I fixed the things reported by checkpatch.pl except
> one long line and a __inline.
> I also removed commented away code and versioning comments.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

> @@ -18,42 +12,42 @@
>  #include "localpara.h"
>  
>  /****************** CONSTANT AND MACRO SECTION ******************************/
> -#define _INLINE      __inline
> +#define _INLINE				__inline

doing s/_INLINE/__inline/ on whole sources would be nice....

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
