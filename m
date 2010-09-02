Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0IBWJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:09:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56354 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0IBWJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Do7LN4AOmjMXBqM+2XpZ0+TMY7m/uhMPX9e0es6YtQrfoX8H6KPjoTuxbu5ilGW/fq
         ywmnhI4FYy2Kx6f17dYGN22VbfXQa0b9SxHPHoVF1cJC5749HgqcTunVKhiGGaN0TegB
         cB/ZwdcpWKH8XWy1VtuHmeTb0SXpT43l9ULpk=
Message-ID: <4C8020C2.2080204@gmail.com>
Date: Thu, 02 Sep 2010 15:10:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: trivial@kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH 82/91] arch/mips/Kconfig Update broken web addresses in
 the arch directory.
References: <1283462022-8024-1-git-send-email-justinmattock@gmail.com> <1283462022-8024-7-git-send-email-justinmattock@gmail.com> <alpine.LFD.2.00.1009022247190.410@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1009022247190.410@eddie.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 02:53 PM, Maciej W. Rozycki wrote:
> On Thu, 2 Sep 2010, Justin P. Mattock wrote:
>
>> The below patch updates a broken web address that is no longer
>> working due to company buyout, and/or change of location.
>> (Please have a look through, and let me know if any of them
>> need to be changed, and I'll resend an updated patch).
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   arch/mips/Kconfig |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>> index 3ad59dd..984b14e 100644
>> --- a/arch/mips/Kconfig
>> +++ b/arch/mips/Kconfig
>> @@ -2178,7 +2178,8 @@ config TC
>>   	  TurboChannel is a DEC (now Compaq (now HP)) bus for Alpha and MIPS
>>   	  processors.  Documentation on writing device drivers for TurboChannel
>>   	  is available at:
>> -	<http://www.cs.arizona.edu/computer.help/policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
>> +	<http://web.archive.org/web/*/http://www.cs.arizona.edu/computer.help/
>> +	  policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
>>
>>   #config ACCESSBUS
>>   #	bool "Access.Bus support"
>
>   This is more<linux-mips@linux-mips.org>; we don't have TURBOchannel
> support for the Alpha (yet?).
>
>   Anyway, a better source should be available; let me see.  Also the
> original document could not have been the most appropriate one -- it looks
> more like a Digital Unix reference, while a set of hardware- and
> firmware-level documents used to be available for TURBOchannel devices
> (and HP probably still publishes them by inertia ;) ).
>
>   Either way, thanks for tracking down these broken links.
>
>    Maciej
>


I'm not sure about the turbo'ness :-)
the webarchive had it there so I just used it.(some sites actually are 
not even archived to my amazement) in any case I'll use what you posted
and resend and the proper time.

Justin P. Mattock
