Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967454Ab2EPLZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:25:47 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49151 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967293Ab2EPLZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <CANqRtoTCo_Vwe8OMS2ovHNimoe_4ZnCEHk5TQ4YPq8oPJXMObg@mail.gmail.com>
References: <20120515154333.6659.66479.sendpatchset@w520>
	<CACRpkdb9LbjvobsJf61VA1Nt8-UCwDZzmjqC8JuN8WPdvhq+iQ@mail.gmail.com>
	<CANqRtoTCo_Vwe8OMS2ovHNimoe_4ZnCEHk5TQ4YPq8oPJXMObg@mail.gmail.com>
Date: Wed, 16 May 2012 13:25:44 +0200
Message-ID: <CACRpkdb4iHomtj5Ue=HmHLLvH==wLuSoMA+uwrp3vTBAPnQr_g@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:15 PM, Magnus Damm <magnus.damm@gmail.com> wrote:

> Do you guys have any preferences how to merge this?
>
> Can I include it together with the EMEV2 SoC bits perhaps? That may be
> easy so we can keep track of the platform data header file dependency.

For ux500 I made a special "gpio and pins" branch and sent through ARM SoC.

Yours,
Linus Walleij
