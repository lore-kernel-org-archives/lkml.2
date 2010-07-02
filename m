Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0GBINw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:13:52 -0400
Received: from bamako.nerim.net ([62.4.17.28]:65032 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab0GBINs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:13:48 -0400
Date: Fri, 2 Jul 2010 10:13:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lars4910@hotmail.com" <lars4910@hotmail.com>,
       "birdie@permonline.ru" <birdie@permonline.ru>,
       "jadcock@cox.net" <jadcock@cox.net>
Subject: Re: [PATCH/RFC] hwmon: Add support for W83667HG-B
Message-ID: <20100702101345.6fe9d27a@hyperion.delvare>
In-Reply-To: <20100702080704.GA12911@ericsson.com>
References: <1278021735-21188-1-git-send-email-guenter.roeck@ericsson.com>
	<20100702092011.0acd753f@hyperion.delvare>
	<20100702080704.GA12911@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010 01:07:04 -0700, Guenter Roeck wrote:
> On Fri, Jul 02, 2010 at 03:20:11AM -0400, Jean Delvare wrote:
> > On Thu, 1 Jul 2010 15:02:15 -0700, Guenter Roeck wrote:
> > > @@ -63,6 +64,7 @@ static const char * w83627ehf_device_names[] = {
> > >  	"w83627dhg",
> > >  	"w83627dhg",
> > >  	"w83667hg",
> > > +	"w83667hg-b",
> > 
> > Dashes aren't allowed in hwmon device names. For consistency with what
> > we did for the W83627DHG-Pg, you should simply drop the "-b". It's a small
> > detail of little interest for the user anyway.
>
> Ok. Actually, since the only real difference was in the registers which
> are not not used anywhere, I'll drop the enum type (w83667hg_b) as well.

Makes sense. It can be added later if needed.

> I'll also add a check for the HG-I.

Do you have a datasheet for that one too?

-- 
Jean Delvare
