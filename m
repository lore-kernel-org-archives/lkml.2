Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2HBTq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 15:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab2HBTq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 15:46:57 -0400
Date: Thu, 2 Aug 2012 15:46:52 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Peter Jones <pjones@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Fix documentation of signed-nokey behavior when
 not enforcing.
Message-ID: <20120802194652.GK1785@zod.bos.redhat.com>
References: <1343936518-16362-1-git-send-email-pjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343936518-16362-1-git-send-email-pjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 03:41:58PM -0400, Peter Jones wrote:
> jwboyer's previous commit changes the behavior of module signing when
> there's a valid signature but we don't know the public key and are in
> permissive mode.  This updates the documentation to match.
> ---

Missing a S-o-B, but otherwise:

Acked-by: Josh Boyer <jwboyer@redhat.com>

>  Documentation/module-signing.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
> index d75d473..8c4bef9 100644
> --- a/Documentation/module-signing.txt
> +++ b/Documentation/module-signing.txt
> @@ -185,7 +185,7 @@ This table indicates the behaviours of the various situations:
>  	MODULE STATE				PERMISSIVE MODE	ENFORCING MODE
>  	=======================================	===============	===============
>  	Unsigned				Ok		EKEYREJECTED
> -	Signed, no public key			ENOKEY		ENOKEY
> +	Signed, no public key			Ok		ENOKEY
>  	Validly signed, public key		Ok		Ok
>  	Invalidly signed, public key		EKEYREJECTED	EKEYREJECTED
>  	Validly signed, expired key		EKEYEXPIRED	EKEYEXPIRED
> -- 
> 1.7.11.2
> 
