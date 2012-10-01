Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2JAKgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:36:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52660 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab2JAKgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:36:47 -0400
Date: Mon, 1 Oct 2012 11:36:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rajanikanth HV <rajanikanth.hv@stericsson.com>
Cc: "francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
Message-ID: <20121001103642.GE6682@gmail.com>
References: <1349064513-31301-1-git-send-email-rajanikanth.hv@stericsson.com>
 <1349064513-31301-2-git-send-email-rajanikanth.hv@stericsson.com>
 <20121001094929.GB6682@gmail.com>
 <50696991.2080103@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50696991.2080103@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> did you have a look at arnd and anton comments regarding
> 'supplied-to' and boolean property

Try to keep your comments inline, situated below the relevant comment.

> >> +     ab8500_battery_info: ab8500_bat_type {
> >> +             battery-type = <2>;
> >> +             thermistor-on-batctrl = <1>;

> > You have this as a bool here, and ...

> >> +     e.g:
> >> +     ab8500_battery_info: ab8500_bat_type {
> >> +             thermistor-on-batctrl;

> > ... a standard property here. I suggest you drop the bool value.

I'm guessing it's just the documentation that needs amending.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
