Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2GQLzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 07:55:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48657 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2GQLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 07:55:39 -0400
Message-ID: <500552A0.7020301@gmail.com>
Date: Tue, 17 Jul 2012 06:55:12 -0500
From: "Gabriel M. Beddingfield" <gabrbedd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rajeev kumar <rajeev-dlh.kumar@st.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/2] MFD: twl6040: Fix revision information
References: <1342432184-12046-1-git-send-email-peter.ujfalusi@ti.com> <1342432184-12046-2-git-send-email-peter.ujfalusi@ti.com> <500508B0.9010009@st.com>
In-Reply-To: <500508B0.9010009@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 01:39 AM, Rajeev kumar wrote:
>> diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
>> index a36e9fc..2786de2 100644
>> --- a/sound/soc/codecs/twl6040.c
>> +++ b/sound/soc/codecs/twl6040.c
>> @@ -653,7 +653,7 @@ int twl6040_get_hs_step_size(struct snd_soc_codec
>> *codec)
>>   {
>>       struct twl6040 *twl6040 = codec->control_data;
>>
>> -    if (twl6040_get_revid(twl6040)<  TWL6040_REV_ES1_2)
>> +    if (twl6040_get_revid(twl6040)<  TWL6040_REV_ES1_3)
>
>
> Instead of doing this change why not you take a #define for revision and
>   do
> if (twl6040_get_revid(twl6040)<  TWL6040_REV)

I disagree.  The driver isn't just for one revision... it's for all of 
them.  Peter's code is pretty clear as to what the situation is.  Your 
suggestion hides it.

-gabriel

