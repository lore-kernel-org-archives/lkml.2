Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab0I0LDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:03:50 -0400
Received: from smtp.nokia.com ([147.243.1.47]:32594 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab0I0LDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:03:48 -0400
Subject: Re: [PATCH 2/4] leds: Driver for National Semiconductors LP5523
 chip
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: "Onkalo Samu.P (Nokia-MS/Tampere)" <samu.p.onkalo@nokia.com>
Cc: "rpurdie@linux.intel.com" <rpurdie@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1285584868.8182.194.camel@masi.mnp.nokia.com>
References: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
	 <1284631946-5350-3-git-send-email-samu.p.onkalo@nokia.com>
	 <1285584868.8182.194.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 27 Sep 2010 14:03:37 +0300
Message-ID: <1285585417.8182.201.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

My original intention was to send my comment directly to Samu. So an
apology to all of you who don't understand Finnish. Basically I was
commenting the use braces in the code fragments below...

Regards,
Matti 


On Mon, 2010-09-27 at 13:54 +0300, Matti J. Aaltonen wrote:
> Moi.
> 
> On Thu, 2010-09-16 at 12:12 +0200, Onkalo Samu.P (Nokia-MS/Tampere)
> wrote:
> > +
> > +       for (i = 0; i < LP5523_ENGINES; i++) {
> > +               if (chip->engines[i].mode == LP5523_CMD_LOAD)
> > +                       sysfs_remove_group(&dev->kobj, &lp5523_engine_group[i]);
> > +       }
> > +
> > +       for (i = 0; i < chip->num_leds; i++)
> > +               sysfs_remove_group(&chip->leds[i].cdev.dev->kobj,
> > +                               &lp5523_led_attribute_group);
> > +}
> 
> Tossa ylla on se asia, josta puhuttiin, style guide sanoo:
> 
> Do not unnecessarily use braces where a single statement will do.
> 
> if (condition)
> 	action();
> 
> Tossa ylla on kummankin for:in jalkeen single statement joista kumpikaan
> ei mahdu yhdelle riville... Mun nakemyksen mukaan ne molemmat olis yhta
> selkeita ilman sulkuja...
> 
> 
> > +       if (mode == LP5523_CMD_RUN)
> > +               ret = lp5523_run_program(engine);
> > +
> > +       else if (mode == LP5523_CMD_LOAD) {
> > +
> > +               lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
> > +               lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
> > +
> > +               ret = sysfs_create_group(&dev->kobj, engine->attributes);
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> 
> Aaltosulut myos if:n jalkeiseen statementtiin....
> 
> t.m.a.
> 
> 


