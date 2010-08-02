Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0HBNaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:30:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42484 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0HBNaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xAx7rTTFEw+0z+fxcwqKxvk4WmjSNWqMF/TelSWaFsl+BgRHdsofbgjpqhm/60qekw
         ZGEM9EgsVzFKSQ03lVdSQYsVkhEGRXmcSuYpF91IKSkVAzKgib0dF9ItSSeje6Yx4ltc
         msgPDv2OlNk/XKwkCDliWATP4ukekfzk5tMnE=
Message-ID: <4C56C86A.2050208@gmail.com>
Date: Mon, 02 Aug 2010 06:30:18 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]udf:super.c Fix warning: variable 'sbi' set but not used
References: <1278564133-19682-1-git-send-email-justinmattock@gmail.com> <4C547367.6070208@gmail.com> <20100802125110.GD3278@quack.suse.cz>
In-Reply-To: <20100802125110.GD3278@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 05:51 AM, Jan Kara wrote:
> On Sat 31-07-10 12:03:03, Justin P. Mattock wrote:
>> any ideas on the status of this?
>    I have it in my tree and will push it to Linus in this merge window.
>
> 								Honza

o.k. cool..

>>
>>> This fixes this warning when building the kernel:
>>>    CC      fs/udf/super.o
>>> fs/udf/super.c: In function 'udf_load_sequence':
>>> fs/udf/super.c:1582:22: warning: variable 'sbi' set but not used
>>> Please have a look, when you have time and let me know.
>>>
>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>
>>> ---
>>>   fs/udf/super.c |    2 --
>>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/udf/super.c b/fs/udf/super.c
>>> index 612d1e2..12bb651 100644
>>> --- a/fs/udf/super.c
>>> +++ b/fs/udf/super.c
>>> @@ -1579,9 +1579,7 @@ static int udf_load_sequence(struct super_block *sb, struct buffer_head *bh,
>>>   {
>>>   	struct anchorVolDescPtr *anchor;
>>>   	long main_s, main_e, reserve_s, reserve_e;
>>> -	struct udf_sb_info *sbi;
>>>
>>> -	sbi = UDF_SB(sb);
>>>   	anchor = (struct anchorVolDescPtr *)bh->b_data;
>>>
>>>   	/* Locate the main sequence */
>>


Justin P. Mattock
