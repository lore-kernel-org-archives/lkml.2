Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1FQFZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 01:25:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35876 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab1FQFZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 01:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=of6QMxjlFyqk7/xPBrXWR97yAbh6O8Tg6zpmEoNJV54aujAoZ5NAi5YojMJ+e+7U3e
         lqn7wF6R/scs54bJAjs2pLqrTv3eT/fZOsKOzFWLY+dCewf9S1VwwZWlVbgrv0S0pnAg
         7KdxfNc7DXQTRlg2XgWc6DOBI7UGTRhioXRjA=
MIME-Version: 1.0
In-Reply-To: <3bea9d0803a4ebfee2bb0f6e42defbf76126dc86.1308287030.git.joe@perches.com>
References: <3bea9d0803a4ebfee2bb0f6e42defbf76126dc86.1308287030.git.joe@perches.com>
Date: Fri, 17 Jun 2011 07:25:48 +0200
X-Google-Sender-Auth: IdsEJwVqHSHSzgTo09Dsna6G-VU
Message-ID: <BANLkTikGtUEYfU=8ZLGLiTdmOd3dE1+btQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2] drivers/net: Remove casts of void *
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        Jie Yang <jie.yang@atheros.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>,
        Rasesh Mody <rmody@brocade.com>, Debashis Dutt <ddutt@brocade.com>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Divy Le Ray <divy@chelsio.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        Jon Mason <jdmason@kudzu.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Steve Hodgson <shodgson@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Daniele Venzano <venza@brownhat.org>,
        David Dillow <dave@thedillows.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 07:08, Joe Perches <joe@perches.com> wrote:
> Unnecessary casts of void * clutter the code.
>
> These are the remainder casts after several specific
> patches to remove netdev_priv and dev_priv.
>
> Done via coccinelle script (and a little editing):
>
> $ cat cast_void_pointer.cocci
> @@
> type T;
> T *pt;
> void *pv;
> @@
>
> - pt = (T *)pv;
> + pt = pv;
>
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> Acked-By: Chris Snook <chris.snook@gmail.com>
> Acked-by: Jon Mason <jdmason@kudzu.us>
>
> ---
>
> v2: Update to Geert's request

[For a2065]
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
