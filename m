Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0KNDhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 22:37:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41784 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0KNDhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 22:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cp1SzPn/nXJlcX2ww4okY8ZlOYM2kuanfu3dWzvY0sfROVPcd/jflRqD5SFpnNfWyQ
         RScC6SW7Z5ZvrujfGrtrdGs3YGLaMmZxVpm8szjqWdsrzGyr1ZtulGMc7Le7SJ0qZ5pm
         FJvE0BZvm/+JaXy9mooOL1DVFBF96/jPYENmU=
MIME-Version: 1.0
In-Reply-To: <4CDEF060.2050000@nctritech.com>
References: <4CDEF060.2050000@nctritech.com>
Date: Sat, 13 Nov 2010 21:37:17 -0600
Message-ID: <AANLkTi=TW+3325Q8PBQ3ZNMDG6te7TXF09_S3heJe_8P@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/Kconfig: CIFS depends on CRYPTO_HMAC
From: Steve French <smfrench@gmail.com>
To: Jody Bruchon <jody@nctritech.com>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged the equivalent of this - thx.

On Sat, Nov 13, 2010 at 2:09 PM, Jody Bruchon <jody@nctritech.com> wrote:
>  I sent this patch in to LKML, but later realized it should probably go
> here.  I don't subscribe to the list, so please CC me directly with any
> replies.  Thanks!
>
> Jody Bruchon
>
> -------- Original Message --------
> Subject:        [PATCH] fs/cifs/Kconfig: CIFS depends on CRYPTO_HMAC
> Date:   Fri, 12 Nov 2010 13:41:06 -0500
> From:   Jody Bruchon <jody@nctritech.com>
> To:     linux-kernel@vger.kernel.org
>
>
> linux-2.6.37-rc1: I compiled a kernel with CIFS which subsequently
> failed with an error indicating it couldn't initialize crypto module
> "hmacmd5".  CONFIG_CRYPTO_HMAC=y fixed the problem.
>
> This patch makes CIFS depend on CRYPTO_HMAC in kconfig.
>
> Signed-off-by: Jody Bruchon<jody@nctritech.com>
> ---
>
> diff -Naur linux-2.6.37-rc1/fs/cifs/Kconfig b/fs/cifs/Kconfig
> --- linux-2.6.37-rc1/fs/cifs/Kconfig    2010-11-12 13:22:31.742999981 -0500
> +++ b/fs/cifs/Kconfig    2010-11-12 13:22:27.528998658 -0500
> @@ -4,6 +4,7 @@
>     select NLS
>     select CRYPTO
>     select CRYPTO_MD5
> +    select CRYPTO_HMAC
>     select CRYPTO_ARC4
>     help
>       This is the client VFS module for the Common Internet File System
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks,

Steve
