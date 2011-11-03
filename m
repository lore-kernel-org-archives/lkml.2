Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375Ab1KCSei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:34:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:43370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865Ab1KCSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:34:37 -0400
Message-ID: <4EB2DEB6.7030508@infradead.org>
Date: Thu, 03 Nov 2011 16:34:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] media: tea5764: reconcile Kconfig symbol and
 macro
References: <1319976530.14409.17.camel@x61.thuisdomein>  <4EAD7E9F.6050709@xenotime.net> <1319994738.14409.37.camel@x61.thuisdomein>  <4EAD8832.9090509@xenotime.net> <1319995903.14409.42.camel@x61.thuisdomein>
In-Reply-To: <1319995903.14409.42.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-10-2011 15:31, Paul Bolle escreveu:
> On Sun, 2011-10-30 at 10:24 -0700, Randy Dunlap wrote:
>> On 10/30/11 10:12, Paul Bolle wrote:
>>> 2) I'm not sure why things are done that way. Why can't builtin drivers
>>> and loadable drivers default to identical values? But perhaps I'm just
>>> misunderstanding the code.
>>
>> They could default to identical values.
> 
> That would make the cleaning up I'm trying to do now somewhat easier. It
> would allow to simplify the drivers a bit too.
> 
>> Maybe someone thinks that
>> it's more difficult to pass parameters to builtin drivers so they
>> just try to use some sane defaults for them instead, whereas it's
>> easy (easier) to pass parameters to loadable modules.  ??
> 
> Perhaps Mauro or the people at linux-media know the reasoning here. Or
> they can show us that I didn't parse the code correctly, of course.

I can't remember the dirty details about this driver, sorry. The first
patch on it might shed some light:


commit 46a60cfef581307d8273919182ae939d44ff7cca
Author: Fabio Belavenuto <belavenuto@gmail.com>
Date:   Tue Dec 30 19:27:09 2008 -0300

    V4L/DVB (10155): Add TEA5764 radio driver
    
    Add support for radio driver TEA5764 from NXP.
    This chip is connected in pxa I2C bus in EZX phones
    from Motorola, the chip is used in phone model A1200.
    This driver is for OpenEZX project (www.openezx.org)
    Tested with A1200 phone, openezx kernel and fm-tools
    
    [mchehab@redhat.com: Fixed CodingStyle and solved some merge conflicts]
    Signed-off-by: Fabio Belavenuto <belavenuto@gmail.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

>From the above, I _suspect_ that the default (whatever it is) is due to
the Motorola A1200 phone. Not sure if it is compiled as module or as builtin
at OpenEZX.


> 
> 
> Paul Bolle
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

