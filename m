Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0IDPLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 11:11:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39011 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0IDPLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 11:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dVIjDsQ2jmBcBsy8eIz195SbbXlPJImPgIIDxyNLEVNhQh9o0WHC9EaEma4egIBG4M
         s1DocwJ8y4UowDPhto/9Eevw/qcAU2/dV7b6Sty0Ak1+IOIhQIGGbuJyaGe10djVCa0y
         GtOa8UpgJH0Jj2plLwYxew7l+WtpDxtkuJ+cg=
MIME-Version: 1.0
In-Reply-To: <1279687926-29360-13-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
	<1279687926-29360-13-git-send-email-justinmattock@gmail.com>
Date: Sat, 4 Sep 2010 17:11:26 +0200
X-Google-Sender-Auth: L6PWt79TQ17RmBOpHLaA_2av1aA
Message-ID: <AANLkTi=VUqpZywUMzwp83BvaOyqobYSqpm6qp6AiK=ZE@mail.gmail.com>
Subject: Re: [PATCH 28/28]Documentation/fb/framebuffer.txt update web address.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 06:52, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> The patch below updates a broken web address.
>
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  Documentation/fb/framebuffer.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/fb/framebuffer.txt b/Documentation/fb/framebuffer.txt
> index fe79e3c..58c5ae2 100644
> --- a/Documentation/fb/framebuffer.txt
> +++ b/Documentation/fb/framebuffer.txt
> @@ -330,7 +330,7 @@ and on its mirrors.
>
>  The latest version of fbset can be found at
>
> -    http://home.tvd.be/cr26864/Linux/fbdev/

FWIW, that exact same page has been at
http://users.telenet.be/geertu/Linux/fbdev/
for the last 4 years (when I had to change ISP). But the contents
haven't changed.

> +    http://www.linux-fbdev.org/

 Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
