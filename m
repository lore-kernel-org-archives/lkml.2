Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab0LIHCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:02:09 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:38150 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0LIHCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MEwEU+RHpSOKePUovOdDVGdtLdM1YcK+8BPvdiGm1RxOJQZLejiWKip545wizuNkA1
         8SsvhCjgXFKGEro6Oh1pk44Pc0hPVHicU31ihifRUKCxPCXy7+8kEwrJsb/OdaceT3nj
         blVhB3sVVOTinzLDlqdIOOUABTXBm+MNlKLRY=
MIME-Version: 1.0
In-Reply-To: <4D007315.1090704@lougher.demon.co.uk>
References: <4D007315.1090704@lougher.demon.co.uk>
Date: Thu, 9 Dec 2010 08:02:04 +0100
X-Google-Sender-Auth: O70sIv9bDicwLHWAT7mUKyHpUws
Message-ID: <AANLkTimUYrb8EMomgmsW+v7ttbkUH0P57SBD5M4_AGmU@mail.gmail.com>
Subject: Re: [PATCH 2/2] Squashfs: Add XZ compression configuration option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>,
        Lasse Collin <lasse.collin@tukaani.org>,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 07:11, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
> --- a/fs/squashfs/Kconfig
> +++ b/fs/squashfs/Kconfig
> @@ -53,6 +53,22 @@ config SQUASHFS_LZO
>
>          If unsure, say N.
>
> +config SQUASHFS_XZ
> +       bool "Include support for XZ compressed file systems"
> +       depends on SQUASHFS
> +       default n

"default n" is the default, no reason to specify it.

Do we need a checkpatch test for this?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
