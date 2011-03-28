Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1C1OkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:40:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40547 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1C1OkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PtVtSp1WiLAQEF8jgu3p5d80var2bVE+zKJp6jON3JZUPt6gB4BesLCUTrsUxaI9Dx
         iD1BBG2kxo82DtebzyI+MUXppqjyPMGZoKMLXBpdLyxMs83vY4ON01urxx4Jid93OXSC
         EOB1c1uucIePkkJ8mPtW2qTK3KBf0Ie4TrNsk=
MIME-Version: 1.0
In-Reply-To: <1301302992-10671-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
References: <1301302992-10671-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
Date: Mon, 28 Mar 2011 16:40:14 +0200
Message-ID: <AANLkTimhcFNDdq0FCP2rVdDJ5V_YP+E82+80OavsuAS=@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mach-ux500: Add CG2900 devices
From: Vitaly Wool <vitalywool@gmail.com>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:03 AM, Par-Gunnar Hjalmdahl
<par-gunnar.p.hjalmdahl@stericsson.com> wrote:
>
> +/* Function located in drivers/staging/cg2900 */
> +extern void cg2900_init_board(void);
> +

I'm confused. Where in the drivers/staging is this function? Couldn't
find it in the previous patch.

~Vitaly
