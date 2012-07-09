Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2GIUen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:34:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36777 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2GIUel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:34:41 -0400
Message-ID: <4FFB405D.6070300@linaro.org>
Date: Mon, 09 Jul 2012 22:34:37 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <4FF6994B.9040801@linaro.org> <20120706173957.GA10202@core.coreip.homeip.net> <4FFB288D.4080606@linaro.org> <20120709201422.GA12242@core.coreip.homeip.net>
In-Reply-To: <20120709201422.GA12242@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why do you keep these assignments and then override them with
> translations? Why don't you do
>
> 	ponkey->idev = input;
> 	ponkey->ab8500 = ab8500;
> 	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
> 	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);
>
> to begin with?

Ah, I see what you mean now.

Sorry, just glossed over your first email.
