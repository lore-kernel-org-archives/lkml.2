Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2HMAih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 20:38:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57647 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2HMAiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 20:38:11 -0400
Date: Mon, 13 Aug 2012 08:38:28 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>, axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] block: Don't use static to define "void *p" in show_partition_start().
References: <201208031307389214790@gmail.com> <501B8EBE.5040006@kernel.dk>, 
	<5027CFA0.1020207@msgid.tls.msk.ru>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208130838250318250@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7D0coEp006732

On 2012-08-12 23:45 Michael Tokarev <mjt@tls.msk.ru> Wrote:
>On 03.08.2012 12:41, Jens Axboe wrote:
>> On 08/03/2012 07:07 AM, majianpeng wrote:
>[]
>>> diff --git a/block/genhd.c b/block/genhd.c
>>> index cac7366..d839723 100644
>>> --- a/block/genhd.c
>>> +++ b/block/genhd.c
>>> @@ -835,7 +835,7 @@ static void disk_seqf_stop(struct seq_file *seqf, void *v)
>>>  
>>>  static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
>>>  {
>>> -	static void *p;
>>> +	void *p;
>>>  
>>>  	p = disk_seqf_start(seqf, pos);
>>>  	if (!IS_ERR_OR_NULL(p) && !*pos)
>> 
>> Huh, that looks like a clear bug. I've applied it, thanks.
>
>It also looks like a -stable material, don't you think?
>
>Thanks,
>
>/mjt
>
Yes, all kernel before this patach had this problem and should apply this patch.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
