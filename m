Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab2KSFBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:01:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45153 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2KSFBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:01:04 -0500
Date: Sun, 18 Nov 2012 20:57:53 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Rajanikanth HV <rajanikanth.hv@linaro.org>
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
Subject: Re: [PATCH 0/4] Implement device tree support for ab8500 BM Devices
Message-ID: <20121119045753.GA28159@lizard>
References: <1351698033-8980-1-git-send-email-rajanikanth.hv@linaro.org>
 <20121119034600.GP29066@lizard.sbx05977.paloaca.wayport.net>
 <CAB4BAkvXZacDVZh2gzooH-Eq8Vnc8JLd=v8=9p-4mLfY0qWavw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAB4BAkvXZacDVZh2gzooH-Eq8Vnc8JLd=v8=9p-4mLfY0qWavw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 09:28:59AM +0530, Rajanikanth HV wrote:
> > FWIW, I fixed these warnings.
> >
> >   CHECK   drivers/power/ab8500_bmdata.c
> > drivers/power/ab8500_bmdata.c:146:23: warning: symbol 'temp_to_batres_tbl_thermistor' was not declared. Should it be static?
> > drivers/power/ab8500_bmdata.c:160:23: warning: symbol 'temp_to_batres_tbl_ext_thermistor' was not declared. Should it be static?
> > drivers/power/ab8500_bmdata.c:171:23: warning: symbol 'temp_to_batres_tbl_9100' was not declared. Should it be static?
> > drivers/power/ab8500_bmdata.c:181:28: warning: symbol 'bat_type_thermistor' was not declared. Should it be static?
> > drivers/power/ab8500_bmdata.c:267:28: warning: symbol 'bat_type_ext_thermistor' was not declared. Should it be static?
> >
> > Plus fixed a few stylistic issues.
> 
> thanks anton for validating my patch, you seems to have older version
> of patch set,
> i am rebasing  new version of patch set to 3.7-rc5, will communicate asap.

Can you please rebase the new work on top of current battery tree (i.e. on
top of the patches that you've sent)? Or that would be too much burden?
