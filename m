Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1BOM6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:58:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62188 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1BOM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:58:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=U1X6uF9ruqAjTA74OEuGGmxcdpBTV+X2RKItJxBq0fhcoLFZTtHoTicoiwYg/IAu/u
         pMaTrDougdf6rc8DeEBT45K1BTWXHsbjOBCp0mSL918/3xDK2a+ftfEppfByblQt0DUu
         J41CSBhbz8K0ZyvNkeYW8JdYX+dEAxNOEotT8=
MIME-Version: 1.0
In-Reply-To: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
Date: Tue, 15 Feb 2011 13:58:00 +0100
X-Google-Sender-Auth: PsZMB5k78GgQp4X7mKihmRul-i4
Message-ID: <AANLkTin7vRMreG3hOAk95MYZUCV-Kr6ac7gD7jgvX6Gf@mail.gmail.com>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
From: Linus Walleij <linus.walleij@linaro.org>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        ext Tony Lindgren <tony@atomide.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
        santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
        felipe.balbi@nokia.com, Jouni Hogander <jouni.hogander@nokia.com>,
        Paul Mundt <lethal@linux-sh.org>, Lee Jones <Lee.Jones@linaro.org>,
        maxime.coquelin-nonst@stericsson.com,
        =?ISO-8859-1?Q?Jonas_=C5berg?= <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/11 Eduardo Valentin <eduardo.valentin@nokia.com>:

> Here is the version 5 of the change to export OMAP data to userspace
> (name, revision, id code, production id and die id).
>
> Basically, this version is still attempting to create a new file under /proc.
> It is the /proc/socinfo, which should be used to export bits which are SoC specific
> (not CPU related, nor machine related).
>
> So, differences between previous version are:
> - merged patch 02/04 with 03/04 to avoid compilation breakages.
> - simplified the seq_file usage by using the single_open and single_release functions
> - exported a function to register a seq_operation .show callback
> - adapted the changes accordingly
>
> As usual, comments are welcome.

Eduardo, what has happened to this patchset?

Now we need something similar for arch/arm/mach-ux500 and I was sort of
hoping that this infrastructure would be in place already... wrong I was.

Do you want help in picking it up and try to polish it up?

Yours,
Linus Walleij
