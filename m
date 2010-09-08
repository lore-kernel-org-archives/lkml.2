Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0IHT15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:27:57 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:52833 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab0IHT1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:27:52 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.589
Message-ID: <4C87E3EC.5050207@tremplin-utc.net>
Date: Wed, 08 Sep 2010 21:28:44 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100809 Mandriva/3.1.2-3mdv2011.0 (2011.0) Thunderbird/3.1.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3: Add axes module parameter for custom axis-mapping
References: <s5htymla56q.wl%tiwai@suse.de>	<s5haanuvypc.wl%tiwai@suse.de>	<4C864B3E.5060603@tremplin-utc.net>	<s5heid58vfv.wl%tiwai@suse.de>	<4C866052.5020206@tremplin-utc.net>	<s5h4oe18rhg.wl%tiwai@suse.de>	<4C868FC0.3040602@tremplin-utc.net> <s5hmxrtuz85.wl%tiwai@suse.de>
In-Reply-To: <s5hmxrtuz85.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-09-10 21:31, Takashi Iwai schreef:
> At Tue, 07 Sep 2010 21:17:20 +0200,
> Éric Piel wrote:
>>
>> Op 07-09-10 18:10, Takashi Iwai schreef:
>>> At Tue, 07 Sep 2010 17:54:58 +0200,
>> :
>>>>>  
>>>>> +module_param_array_named(axes, lis3_dev.axis_map, int, NULL, 0644);
>>>>> +MODULE_PARM_DESC(axes, "Axis-mapping for x,y,z directions");
>>>> But now there is no check at all about the value being between 1 and 3,
>>>> is there?
>>>> I think it's still necessary to have a small function which checks for
>>>> correct values, otherwise the user could read a bit anywhere in the memory.
>>>
>>> Ah, right, it's accessing the array index.  This must be fixed indeed.
>>> Another revised version below.
>>>
>> It seems to be the same patch as the previous version. You probably
>> attached the wrong patch.
> 
> Oops, sorry.  Attached below.
> 
Looks good to me. Thanks Takashi.

Acked-by: Éric Piel <eric.piel@tremplin-utc.net>

Andrew, would you mind picking it up?
Eric
