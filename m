Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1FCExT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 00:53:19 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:64752 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1FCExS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 00:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:references:subject:date:mime-version
         :content-type:content-transfer-encoding:x-priority:x-msmail-priority
         :x-mailer:x-mimeole;
        b=j5BVOXkQTm2QHnS80qBlkw14XzhVkkDJ/zdpONg2/SrvPOC9RmnSsVDLgMIRY7zviO
         jVhBDdthS/XD8H4ded/lqdbfedgCNZ+J1uww0iKQj6OV5TdM5m9KvZVgrGOfo3QODoEc
         EKdUWGf7qFHpjfe1E9WvQvX3HbXan5Poewa00=
Message-ID: <B4B144EDA1BA4138AFAC732D06C60F8B@WWW67E861F6858>
From: "Guowen Li" <guowen.li.linux@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>
References: <201106011918.47939.guowen.li.linux@gmail.com> <1307069404.3667.35.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] Fix compiler warning in ftrace.c
Date: Fri, 3 Jun 2011 12:52:59 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p534rUvI025217

Thank you for pointing them out, i will be careful next time. :)

Signed-off-by: Guowen Li <guowen.li.linux@gmail.com>
----- Original Message ----- 
From: "Steven Rostedt" <rostedt@goodmis.org>
To: "GuoWen Li" <guowen.li.linux@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Sent: Friday, June 03, 2011 10:50 AM
Subject: Re: [PATCH] Fix compiler warning in ftrace.c


> Couple of things:
> 
> On Wed, 2011-06-01 at 19:18 +0800, GuoWen Li wrote:
>> kernel/trace/ftrace.c: In function â€˜ftrace_regex_write.clone.15â€™:
>> kernel/trace/ftrace.c:2743:6: warning: â€˜retâ€™ may be used uninitialized in this 
>> function
>> 
>> Signed-off-by: GuoWen Li
> 
> Please add your mail address to your SOB. (I'll fix it)
> 
>> ---
>>  kernel/trace/ftrace.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 1ee417f..204b3eb 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -2740,7 +2740,7 @@ static int ftrace_process_regex(struct ftrace_hash 
>> *hash,
>>  {
>>         char *func, *command, *next = buff;
>>         struct ftrace_func_command *p;
>> -       int ret;
>> +       int ret = -EINVAL;
> 
> This patch has horrible white space issues. (I fixed it)
> 
> -- Steve
> 
> 
>>  
>>         func = strsep(&next, ":");
> 
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
