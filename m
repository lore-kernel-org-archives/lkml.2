Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435Ab0HMJ5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761413Ab0HMJ5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:57:15 -0400
Message-ID: <4C651800.6030804@redhat.com>
Date: Fri, 13 Aug 2010 12:01:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Laurens Leemans <laurens@signips.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: Add support for the Fintek F71808E
References: <20100801132226.GE3711@salidar.me.mortis.eu> <1280669402-31213-1-git-send-email-me@mortis.eu> <4C5950B6.5010503@redhat.com> <20100810191117.GN14382@salidar.me.mortis.eu>
In-Reply-To: <20100810191117.GN14382@salidar.me.mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/10/2010 09:11 PM, Giel van Schijndel wrote:
> On Wed, Aug 04, 2010 at 01:36:22PM +0200, Hans de Goede wrote:
>> On 08/01/2010 03:30 PM, Giel van Schijndel wrote:
>>> Allow device probing to recognise the Fintek F71808E.
>>>
>>> Sysfs interface:
>>>    * Fan/pwm control is the same as for F71889FG
>>
>> My datasheet strongly disagrees with this ...
>
> I just noticed this patch was applied to mainline anyway.  Regardless, I
> will (try to) address these issues you raised.
>
> Right now however, I am prioritising personal stuff above this
> driver---bachelor's thesis and graduation presentation.  When finished
> with that (september) I'll allocate time to these issues again.
>

I've send a mail directly to akpm asking for this to be removed, hopefully
this will help.

> PPS I do have a patch ready that addresses some of the issues you
>      raised.  Those are only the cosmetic changes though (e.g. change
>      naming of chip, comment updates, etc.).  Would you suggest me to
>      send it right now already or wait until I have time to address the
>      other issues as well?

My goal for 2.6.36 is to pull the patch, and then we can wait til all
issues are fixed properly before re-introducing it.

Regards,

Hans
