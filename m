Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab0E2OVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 10:21:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55128 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab0E2OVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 10:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=S+a4pLXh9t/HROh/9rcT0YZGfuyHqyPNNJEhh3pTP+FAz6sXzM/R64+mmHPf6nr00c
         ZslWY7d2M3pS7uaFWYgTbESFSVAvfyUhbtbWEimC6WSE8IgM7D9i634kICtCRGmWxKq+
         D3533tV8I8e+i7R0g9RSHxbQ0617uxTUHt8gU=
MIME-Version: 1.0
In-Reply-To: <4BFC7269.3070309@lougher.demon.co.uk>
References: <4BFC7269.3070309@lougher.demon.co.uk>
Date: Sat, 29 May 2010 16:21:17 +0200
X-Google-Sender-Auth: 59Wz5u0C-kce-Du37YzTuy8Lf6I
Message-ID: <AANLkTilWjRvjl5M_4lenw3aMI57eDYjOV96k3KmxrNwB@mail.gmail.com>
Subject: Re: [GIT PULL] Squashfs updates for 2.6.35
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 02:59, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
> Stephen Hemminger (2):
>      squashfs: xattr fix sparse warnings

Interestingly, this one introduced a new compiler warning:

fs/squashfs/xattr.c:37: warning: ‘squashfs_xattr_handler’ declared
inline after being called
fs/squashfs/xattr.c:37: warning: previous declaration of
‘squashfs_xattr_handler’ was here

as the actual function is still marked inline at line 298.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
