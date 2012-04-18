Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab2DRGs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:48:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42960 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856Ab2DRGsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:48:55 -0400
X-Sasl-enc: wUyajL63Pcv5OM7XmWl8n1N8c04RH9gxxZkUOS9wrTCN 1334731733
Message-ID: <4F8E6494.60206@ladisch.de>
Date: Wed, 18 Apr 2012 08:52:04 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ondrej Zary <linux@rainbow-software.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] Add Wolfson Microelectronics WM8776
 codec ALSA driver
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org> <201204172015.14582.linux@rainbow-software.org> <s5hy5punpem.wl%tiwai@suse.de> <201204172307.58016.linux@rainbow-software.org> <s5hr4vloa8g.wl%tiwai@suse.de>
In-Reply-To: <s5hr4vloa8g.wl%tiwai@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Ondrej Zary wrote:
>> On Tuesday 17 April 2012 21:12:33 you wrote:
>>> Ondrej Zary wrote:
>>>> Xonar (oxygen) has a private version of these drivers too. It could be
>>>> converted to use common code instead.
>>>
>>> Hm, only if the generated controls do match with your case,..
>>> It's case by case, especally if there is only one another candidate.
>>
>> Control names can be changed (and also disabled) by the driver. In fact,
>> psc724 does exactly this as is needs the WM8776 controls to be named
>> as "front" and WM8766 as "rear".
>> I don't see any problem if something needs to be changed for this code to be
>> used by Xonar (or some other driver).
>
> OK, it depends on Clemens, whether the shared code is preferred (and
> maintainable).

I've always planned to move the Xonar driver to the ASoC framework.
(I didn't at first because ASoC didn't support multiple codecs then.)
The only problem is finding time to do this ...

Sharing the code between ice1712 and xonar might be a first step.


Regards,
Clemens
