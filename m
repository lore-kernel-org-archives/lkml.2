Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678Ab2IGN6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:58:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62204 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab2IGN6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:58:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 00/19] First HREF Device Tree enablement patch-set
Date: Fri, 7 Sep 2012 13:58:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <201209071241.17198.arnd@arndb.de> <20120907130114.GF29601@gmail.com>
In-Reply-To: <20120907130114.GF29601@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071358.38598.arnd@arndb.de>
X-Provags-ID: V02:K0:43B2YnA1/+08yIeZbq1ubD4T2rM5Fzzd5Hx6Djau7sn
 nKsKKFrr6jN3vyg+tlxA7sCQEOkEJQXApRd3umfYCaiswW0PNk
 3mo1C4JLEqLUb8HJAMd0AOhbNk0TQUk3gHoMQyn7OsjlX9tb/m
 Tyvlt0G0fJX5l4vk9Pc10arBaa1LJVJ0Cc72dXPwPjSx74J5nQ
 SzLovYe+COwy2GGKW2njDJX2c9YUHAvEKa56315zC/SNfuQn3p
 b0TvTBFXfPUWC9vgblKCS1rDwja7bbosoIG5ai2gE03BkKp41l
 D/N+hbJ7PV7TmbVMLhnA6RCM/mKZ5hMx0fkkSgI7jgwh5YpAEJ
 gnPFhTDe32tpYNo05y9I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Lee Jones wrote:
> Just running this by you, as there is method in the madness.
> 
> Linus wanted to keep changes to the Device Tree and changes
> in platform code separate, which is my reason for submitting
> all of my changes to date that way.
> 
> What I do (not sure if I've achieved that here yet, I'll need
> to take another look) is; make changes to the driver which
> enable it for Device Tree use. Then apply the DT node and remove 
> platform registration in two subsequent patches respectively. 
> Then when we come to bisect and land in between them we still
> have a perfectly working driver, only the second probe fails 
> which the only side-effect is some warnings in the boot log.

I'm sorry that you are getting conflicting directions from Linus
and me. We can use the approach you suggest here this time,
but I'd prefer if we can all agree on how to do this in the
future.

Linus: What is the reason you want to see the commits split up
like this? We normally try to split up changes into small
atomic improvements, but splitting them even further seems
counterproductive, and loses the context information in the
changeset description.

	Arnd
