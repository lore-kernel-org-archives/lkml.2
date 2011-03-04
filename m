Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab1CDKRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:17:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41496 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab1CDKRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ruK9JDk/GUQlAL4fQylyrJPtFwhg0uds0+Du9wKebE7vrBW4kouJBcerh2U8V0J1D0
         UQ50Wf9/ss6iX/0GKFHo/AHhJWoY3mqvMQiN2h9mf6aguj7bh/DzTzNuX2nTPzMbUwHp
         8AtV7mM+NQO88gOtiaqOdskhGlZKHuaRz4uEs=
MIME-Version: 1.0
In-Reply-To: <1290060899-9786-1-git-send-email-ccross@android.com>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
Date: Fri, 4 Mar 2011 11:17:08 +0100
Message-ID: <AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency with cpufreq notifiers
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists-infradead.org,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Rickard ANDERSSON <Rickard.Andersson@stericsson.com>,
        Rob Herring <robherring2@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Persson <martin.persson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/18 Colin Cross <ccross@android.com>:

> The clock to the ARM TWD local timer scales with the cpu
> frequency. To allow the cpu frequency to change while
> maintaining a constant TWD frequency, pick a lower target
> frequency for the TWD and use the prescaler to divide down
> to the closest lower frequency.

We are using this with some custom hooks for the U8500.

Tested-by: Linus Walleij <linus.walleij@linaro.org>

Martin Persson can probably provide an additional Tested-by
from ST-Ericsson if it helps.

Colin are you merging this patch for 2.6.39 through
Russells tracker or pull request? It's an important patch
for us.

Yours,
Linus Walleij
