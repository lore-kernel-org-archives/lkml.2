Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161055Ab2KWJzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:55:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59341 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161025Ab2KWJzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:55:21 -0500
Date: Fri, 23 Nov 2012 09:55:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
Cc: anton.vorontsov@linaro.org, rob.herring@calxeda.com, robherring2@gmail.com,
        francescolavra.fl@gmail.com, arnd@arndb.de,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, STEricsson_nomadik_linux@list.st.com,
        "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Subject: Re: [PATCH] mfd: ab8500: add static linkage for battery info
Message-ID: <20121123095516.GJ17471@gmail.com>
References: <1353644071-14142-1-git-send-email-rajanikanth.hv@stericsson.com>
 <20121123094800.GH17471@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121123094800.GH17471@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How do you want this patch to be treated?
>
> Is this a patch or a branch? If it's a branch, why are you referencing
> it? Have you issued a pull request? If it's a patch (I'm assuming it
> hasn't been accepted yet), then you should just fix it up into the
> patch.

My apologies, I've just seen Anton's message to you.

> > From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
> > 
> > enforce static linkage for battery attributes structures

    <subsystem>: Enforce static linkage for battery attributes structures
                 ^
                 Capital letter to start a sentence.

It's always worth doing `git log --oneline <subsystem>` to see how
the maintainer likes their $SUBJECT lines to be structured.

> > this patch is against: "mfd-ab8500-add-devicetree-support-for-fuelgauge"

There's no need to say this, please remove this line.

You also need a short description of what you're actually doing
in the patch.

> > Signed-off-by: Rajanikanth H.V <rajanikanth.hv@linaro.org>
> > ---
> >  drivers/power/ab8500_bmdata.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
> > index ff8f055..db17930 100644
> > --- a/drivers/power/ab8500_bmdata.c
> > +++ b/drivers/power/ab8500_bmdata.c
> > @@ -143,7 +143,7 @@ static struct abx500_res_to_temp temp_tbl[] = {
> >   * Note that the batres_vs_temp table must be strictly sorted by falling
> >   * temperature values to work.
> >   */
> > -struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
> > +static struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
> >  	{ 40, 120},
> >  	{ 30, 135},
> >  	{ 20, 165},
> > @@ -157,7 +157,7 @@ struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
> >   * Note that the batres_vs_temp table must be strictly sorted by falling
> >   * temperature values to work.
> >   */
> > -struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
> > +static struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
> >  	{ 60, 300},
> >  	{ 30, 300},
> >  	{ 20, 300},
> > @@ -168,7 +168,7 @@ struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
> >  };
> >  
> >  /* battery resistance table for LI ION 9100 battery */
> > -struct batres_vs_temp temp_to_batres_tbl_9100[] = {
> > +static struct batres_vs_temp temp_to_batres_tbl_9100[] = {
> >  	{ 60, 180},
> >  	{ 30, 180},
> >  	{ 20, 180},
> > -- 
> > 1.7.10.4
> > 
> 
> -- 
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
