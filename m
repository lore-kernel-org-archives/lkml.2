Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0DZKJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:09:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0DZKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wWutMYOKzb7grmjjlozYxC31OndwV+7FU18YKpHTkACjciORfLJzZyQJ1UqETX/I3m
         7E8pcgnSDC/7CkPntEhU1Zr5oPGnX8WQDPSD+a5dTVnLx8ci7vLDbhg711jgZ7evL5El
         9+bN0qyUj8yzqbovUmR1bO4Fjiz9xl28RCD6g=
Date: Mon, 26 Apr 2010 14:09:01 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org,
       Yulia Vilensky <vilensky@compulab.co.il>
Subject: Re: [PATCH] ds2782_battery: add support for ds2786 battery gas
 gauge
Message-ID: <20100426100901.GA2092@oksana.dev.rtsoft.ru>
References: <20100422071437.GA32489@oksana.dev.rtsoft.ru>
 <1271921723-18289-1-git-send-email-mike@compulab.co.il>
 <4BD0BE97.6010007@bluewatersys.com>
 <4BD460D3.1020609@compulab.co.il>
 <4BD4A9B4.1010200@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4BD4A9B4.1010200@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 08:44:36AM +1200, Ryan Mallon wrote:
[...]
> >>>  config BATTERY_DS2782
> >>> -    tristate "DS2782 standalone gas-gauge"
> >>> +    tristate "DS2782/DS2786 standalone gas-gauge"
> >>>      depends on I2C
> >>>      help
> >>> -      Say Y here to enable support for the DS2782 standalone battery
> >>> +      Say Y here to enable support for the DS2782/DS2786 standalone
> >>> battery
> >>
> >> I have only used the DS2782 chip. Can we just change this to DS278x? May
> >> as well change to CONFIG_BATTERY_DS278x while we are here.
> >>
> > 
> > Shall we move ds2782_battery.c to ds278x_battery.c at the same time?
> > Changing Kconfig invites the .c file move as well :)
> 
> Yes. Are there other gas-gauges in the same family?

Please don't, this is an unneeded churn. I'd won't bother with
renaming Kconfig symbol as well (and btw, that renaming will
break oldconfig, so I strongly suggest not to do it).

So, your current approch of changing the description and help
text is OK.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
