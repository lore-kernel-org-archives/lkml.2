Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0HPQPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:15:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55365 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab0HPQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YWEa12yBh2dtX8DbiVtJ8sSD6FF30XmqtHBu05k6oWcZEWSJknqhMa9fGc+g7ouXcq
         jmSAVM5JmqTe+ZT913zySlwEUtdGs3XMnsLm8iyZhN5PGvHwXnNKkeE3QnErdRvVhIBN
         8ZMQhRW7p7EARCL/xSGV85KBu66IGvHXhuuCM=
Message-ID: <4C69645E.7090308@gmail.com>
Date: Mon, 16 Aug 2010 09:16:30 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]drivers/video/vesafb.c Fix a typo.
References: <1281804202-27500-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1008161514050.1019@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1008161514050.1019@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 06:14 AM, Jiri Kosina wrote:
> On Sat, 14 Aug 2010, Justin P. Mattock wrote:
>
>> ---
>>   drivers/video/vesafb.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
>> index 090aa1a..6a069d0 100644
>> --- a/drivers/video/vesafb.c
>> +++ b/drivers/video/vesafb.c
>> @@ -253,7 +253,7 @@ static int __init vesafb_probe(struct platform_device *dev)
>>   	size_vmode = vesafb_defined.yres * vesafb_fix.line_length;
>>
>>   	/*   size_total -- all video memory we have. Used for mtrr
>> -	 *                 entries, ressource allocation and bounds
>> +	 *                 entries, resource allocation and bounds
>>   	 *                 checking. */
>>   	size_total = screen_info.lfb_size * 65536;
>>   	if (vram_total)
>
> Applied, thanks.
>

cool... there's another web address that I can send to you, but need to 
look through and find the original e-mail first before...

Justin P. Mattock
