Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2KSDtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 22:49:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2KSDtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 22:49:12 -0500
Date: Sun, 18 Nov 2012 19:46:00 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Cc: rob.herring@calxeda.com, lee.jones@linaro.org, francescolavra.fl@gmail.com,
        arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 0/4] Implement device tree support for ab8500 BM Devices
Message-ID: <20121119034600.GP29066@lizard.sbx05977.paloaca.wayport.net>
References: <1351698033-8980-1-git-send-email-rajanikanth.hv@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351698033-8980-1-git-send-email-rajanikanth.hv@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 03:40:29PM +0000, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> This patch-set adds device tree binding for ab8500 battery-managed
> devices. Removes the redundant platform structure maintained
> across bm devices and implements common DT probe routine across all the
> modules.

Thanks for the patches, Rajanikanth.

The mfd changes seemed very minor, so I impudently applied the patches to
the battery tree. :)

(But I'm bouncing the patches to Samuel and Mark anyway, jfyi.)

p.s.

FWIW, I fixed these warnings.

  CHECK   drivers/power/ab8500_bmdata.c
drivers/power/ab8500_bmdata.c:146:23: warning: symbol 'temp_to_batres_tbl_thermistor' was not declared. Should it be static?
drivers/power/ab8500_bmdata.c:160:23: warning: symbol 'temp_to_batres_tbl_ext_thermistor' was not declared. Should it be static?
drivers/power/ab8500_bmdata.c:171:23: warning: symbol 'temp_to_batres_tbl_9100' was not declared. Should it be static?
drivers/power/ab8500_bmdata.c:181:28: warning: symbol 'bat_type_thermistor' was not declared. Should it be static?
drivers/power/ab8500_bmdata.c:267:28: warning: symbol 'bat_type_ext_thermistor' was not declared. Should it be static?

Plus fixed a few stylistic issues.

Thanks,
Anton.
