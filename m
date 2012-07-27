Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2G0Pr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:47:56 -0400
Received: from mail.tpi.com ([70.99.223.143]:3136 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab2G0Prz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:47:55 -0400
Message-ID: <5012B792.20400@canonical.com>
Date: Fri, 27 Jul 2012 09:45:22 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] ivtv: Declare MODULE_FIRMWARE usage
References: <1343327180-94759-1-git-send-email-tim.gardner@canonical.com> <1343341295.2575.18.camel@palomino.walls.org>
In-Reply-To: <1343341295.2575.18.camel@palomino.walls.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 04:21 PM, Andy Walls wrote:
> On Thu, 2012-07-26 at 12:26 -0600, Tim Gardner wrote:
>> Cc: Andy Walls <awalls@md.metrocast.net>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: ivtv-devel@ivtvdriver.org
>> Cc: linux-media@vger.kernel.org
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> ---
>>  drivers/media/video/ivtv/ivtv-firmware.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/video/ivtv/ivtv-firmware.c b/drivers/media/video/ivtv/ivtv-firmware.c
>> index 02c5ade..6ec7705 100644
>> --- a/drivers/media/video/ivtv/ivtv-firmware.c
>> +++ b/drivers/media/video/ivtv/ivtv-firmware.c
>> @@ -396,3 +396,7 @@ int ivtv_firmware_check(struct ivtv *itv, char *where)
>>  
>>  	return res;
>>  }
>> +
>> +MODULE_FIRMWARE(CX2341X_FIRM_ENC_FILENAME);
>> +MODULE_FIRMWARE(CX2341X_FIRM_DEC_FILENAME);
>> +MODULE_FIRMWARE(IVTV_DECODE_INIT_MPEG_FILENAME);
> 
> Only the PVR-350, based on the iTVC-15/CX23415 chip, needs the
> CX2341X_FIRM_DEC_FILENAME and IVTV_DECODE_INIT_MPEG_FILENAME.  (And even
> in the case of that card, not having the IVTV_DECODE_INIT_MPEG_FILENAME
> file is non-fatal.)
> 
> I would not want anything in user-space or kernel space preventing the
> ivtv module from loading, if some of those files don't exist.
> 
> Regards,
> Andy
> 

MODULE_FIRMWARE is informational only and has no runtime impact.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
