Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0HIJWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:22:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51538 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab0HIJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iJ/L0uib8Fk8ieg2CmnuEypi5vBxFNirMc2R30DR1KQ1x7ukj4kkhp52GGZgj1w41X
         fGN9p9wI7FnoHa7V0WdZ/YzA0ponkrkTJTlyN+w4iP9Td/jPXEnpyoHc9lDfoUf/W+XO
         pB4THz/1g6nI+ZU/rDY0BeADwexBbHLZVSWAo=
Message-ID: <4C5FC8FA.5070600@gmail.com>
Date: Mon, 09 Aug 2010 02:23:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH]Documentation update broken web addresses.
References: <1279943484-31069-1-git-send-email-justinmattock@gmail.com> <4C547464.6000505@gmail.com> <alpine.LNX.2.00.1008041521480.29919@pobox.suse.cz> <4C596C75.9070505@gmail.com> <alpine.LNX.2.00.1008091112320.29919@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1008091112320.29919@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 02:13 AM, Jiri Kosina wrote:
> On Wed, 4 Aug 2010, Justin P. Mattock wrote:
>
>>> I have now applied it. Please keep in mind, for your future submissions,
>>> to make sure that you handle UTF-8 correctly. I had to manually fix your
>>> patch for files in Japaneese, Korean and Chineese languages.
>>>
>>> Thanks,
>>>
>>
>> thanks!!
>> yeah I did see those where churned up, but couldnt figure out why sending
>> individually the language came out fine, but with the whole lot the churn
>> would happen.
>>
>> just to make sure there was a change(not sure if you received my previous
>> post) with an address at:
>>
>> Documentation/filesystems/affs.txt
>> (https://patchwork.kernel.org/patch/113264/)
>>
>> this address seems to be a better location
>> http://www.amigaemulator.org/
>>
>> wanted to wait until if I received other such changes before resending again,
>> but it's too late it's already applied
>
> The patch is already in Linus' tree, so if there are any changed that
> should be applied on top of your previous patch, please send them my way.
>
> Thanks,
>


alright.. cool.. I'll have a look and see. also keep in mind theres also 
the rest of the kernel that probably should be checked I don't mind 
going through that.. but will take some time and patience etc...

Justin P. Mattock
