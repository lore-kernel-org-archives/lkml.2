Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1JTFZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:25:19 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:24834 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1JTFZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 01:25:16 -0400
Message-ID: <4E9FB0D6.9080301@snapgear.com>
Date: Thu, 20 Oct 2011 15:25:42 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/21 v2] m68k: drop unused Kconfig symbols
References: <1318925407.6414.22.camel@x61.thuisdomein>	 <4E9D6C05.9040106@snapgear.com> <1318941043.6414.35.camel@x61.thuisdomein>
In-Reply-To: <1318941043.6414.35.camel@x61.thuisdomein>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 18/10/11 22:30, Paul Bolle wrote:
> On Tue, 2011-10-18 at 22:07 +1000, Greg Ungerer wrote:
>>> - dropped SOM5282EM too (discovered this while doing this second
>>>     version, my scripts aren't smart enough too catch it)
>>
>> Hmm. I don't want to lose the SOM5282EM config option. Although it
>> isn't used inside the code it does let the configurer know that this
>> specific board is supported.
>
> Isn't there another way? You're also adding a configuration option. This
> means your configurer has to make a decision whether or not to enable
> support for that board while this decision actually has no effect.

Yes, that is the idea. The configurer doesn't need to know it has
no effect (at least currently anyway). But they know that the board
is supported.


> Apparently that support comes for free (I'm guessing once M528x support
> is enabled, I haven't checked that). Wouldn't a comment do? Or adding a
> line to some help text?
>
> In the mean time I suppose you're willing to fix this part of my patch
> yourself (ie, I don't have to redo this again).

Yes, thats fine, I will fix it and apply.

Geert: are you ok with the changes?

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
