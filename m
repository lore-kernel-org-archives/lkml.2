Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321Ab2KWJuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:50:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35669 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030282Ab2KWJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:50:06 -0500
Date: Fri, 23 Nov 2012 09:50:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>, rob.herring@calxeda.com,
        robherring2@gmail.com, francescolavra.fl@gmail.com, arnd@arndb.de,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, STEricsson_nomadik_linux@list.st.com,
        rajanikanth.hv@stericsson.com
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
Message-ID: <20121123095000.GI17471@gmail.com>
References: <1353609827-8218-1-git-send-email-rajanikanth.hv@linaro.org>
 <1353609827-8218-2-git-send-email-rajanikanth.hv@linaro.org>
 <20121122200841.GB12397@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121122200841.GB12397@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, Nov 23, 2012 at 12:13:44AM +0530, Rajanikanth H.V wrote:
> [...]
> > +/*
> > + * Note that the batres_vs_temp table must be strictly sorted by falling
> > + * temperature values to work.
> > + */
> > +struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
> 
> It must be static.
> 
> [..]
> > +struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
> 
> Ditto.
> 
> > +	{ 60, 300},
> > +	{ 30, 300},
> > +	{ 20, 300},
> > +	{ 10, 300},
> > +	{ 00, 300},
> > +	{-10, 300},
> > +	{-20, 300},
> > +};
> > +
> > +/* battery resistance table for LI ION 9100 battery */
> > +struct batres_vs_temp temp_to_batres_tbl_9100[] = {
> 
> Ditto.
> 
> There are other issues, which I fixed in my tree for the previous series.
> So the previous series already merged, please post patches on top of it.

Ah, I see now. My apologies, I'll re-comment.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
