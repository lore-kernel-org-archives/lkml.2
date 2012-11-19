Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2KSD7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 22:59:01 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50235 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2KSD7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 22:59:00 -0500
MIME-Version: 1.0
In-Reply-To: <20121119034600.GP29066@lizard.sbx05977.paloaca.wayport.net>
References: <1351698033-8980-1-git-send-email-rajanikanth.hv@linaro.org>
	<20121119034600.GP29066@lizard.sbx05977.paloaca.wayport.net>
Date: Mon, 19 Nov 2012 09:28:59 +0530
Message-ID: <CAB4BAkvXZacDVZh2gzooH-Eq8Vnc8JLd=v8=9p-4mLfY0qWavw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Implement device tree support for ab8500 BM Devices
From: Rajanikanth HV <rajanikanth.hv@linaro.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: rob.herring@calxeda.com, Lee Jones <lee.jones@linaro.org>,
        Francesco Lavra <francescolavra.fl@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "linaro-dev@lists.linaro.org Devel" <linaro-dev@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        STEricsson_nomadik_linux@list.st.com,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 19 November 2012 09:16, Anton Vorontsov <anton.vorontsov@linaro.org> wrote:
> (But I'm bouncing the patches to Samuel and Mark anyway, jfyi.)
>
> p.s.
>
> FWIW, I fixed these warnings.
>
>   CHECK   drivers/power/ab8500_bmdata.c
> drivers/power/ab8500_bmdata.c:146:23: warning: symbol 'temp_to_batres_tbl_thermistor' was not declared. Should it be static?
> drivers/power/ab8500_bmdata.c:160:23: warning: symbol 'temp_to_batres_tbl_ext_thermistor' was not declared. Should it be static?
> drivers/power/ab8500_bmdata.c:171:23: warning: symbol 'temp_to_batres_tbl_9100' was not declared. Should it be static?
> drivers/power/ab8500_bmdata.c:181:28: warning: symbol 'bat_type_thermistor' was not declared. Should it be static?
> drivers/power/ab8500_bmdata.c:267:28: warning: symbol 'bat_type_ext_thermistor' was not declared. Should it be static?
>
> Plus fixed a few stylistic issues.

thanks anton for validating my patch, you seems to have older version
of patch set,
i am rebasing  new version of patch set to 3.7-rc5, will communicate asap.
