Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0LaWdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 17:33:13 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:56219 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab0LaWdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 17:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=duxVipDaQEz9g6LpUWXFt+GUPC6XVWTAnCbv7n0//Ha6ms7ssSI1QNUhXy01WnjEnG
         wPXGkjuyjVjlGuj6zfqb+GUsiNxsP1aU7pnxkf9XHVL1g/7B0evrUmUZUBqeY3/hOzLG
         GJS7G1LXdNVR6wH4MNB2Jx3LQgm1zhCTQP3Bc=
Message-ID: <4D1E5A3B.4000104@gmail.com>
Date: Fri, 31 Dec 2010 14:33:31 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: trivial@kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 11/15]drivers:media:video:cx18:cx23418.h Typo change diable
 to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-5-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-6-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-7-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-8-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-9-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-10-git-send-email-justinmattock@gmail.com>	 <1293750484-1161-11-git-send-email-justinmattock@gmail.com> <1293830120.2410.11.camel@localhost>
In-Reply-To: <1293830120.2410.11.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2010 01:15 PM, Andy Walls wrote:
> On Thu, 2010-12-30 at 15:08 -0800, Justin P. Mattock wrote:
>> The below patch fixes a typo "diable" to "disable". Please let me know if this
>> is correct or not.
>       ^^^^^^^^^^^^^^
>
> What, else could it be?  The "diablo" chroma spatial filter type? ;)
>
> Looks fine.
>
> Acked-by: Andy Walls<awalls@md.metrocast.net>

depends on what the search engine gives you.. diablo did show up
but figured better throw that in to be safe since some definitions 
appear to be incorect but are in fact correct..

>
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/media/video/cx18/cx23418.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/cx18/cx23418.h b/drivers/media/video/cx18/cx23418.h
>> index 2c00980..7e40035 100644
>> --- a/drivers/media/video/cx18/cx23418.h
>> +++ b/drivers/media/video/cx18/cx23418.h
>> @@ -177,7 +177,7 @@
>>      IN[0] - Task handle.
>>      IN[1] - luma type: 0 = disable, 1 = 1D horizontal only, 2 = 1D vertical only,
>>   		      3 = 2D H/V separable, 4 = 2D symmetric non-separable
>> -   IN[2] - chroma type: 0 - diable, 1 = 1D horizontal
>> +   IN[2] - chroma type: 0 - disable, 1 = 1D horizontal
>>      ReturnCode - One of the ERR_CAPTURE_... */
>>   #define CX18_CPU_SET_SPATIAL_FILTER_TYPE     	(CPU_CMD_MASK_CAPTURE | 0x000C)
>>
>
>
>

cheers,

Justin P. Mattock
