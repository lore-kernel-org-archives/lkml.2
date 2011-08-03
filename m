Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1HCCbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 22:31:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50972 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab1HCCbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 22:31:09 -0400
Message-ID: <4E38B2F1.8040903@cn.fujitsu.com>
Date: Wed, 03 Aug 2011 10:31:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
References: <4E38AB50.9040804@gmail.com> <4E38AC92.4090501@cn.fujitsu.com> <4E38AFC2.3070608@gmail.com>
In-Reply-To: <4E38AFC2.3070608@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 10:30:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 10:30:09
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Sheng-Hui wrote:
> On 2011年08月03日 10:04, Li Zefan wrote:
>> 09:58, Wang Sheng-Hui wrote:
>>> The patch is against 3.0
>>>
>>> The arg of kjournald/kjournald2 is void *, and points to type
>>> journal_t. We should convert it to journal_t * explicitly in
>>> the kjournald/kjournald2 function body.
>>>
>>
>> Why?
>>
>> Implicit convertion from void * to foo * is ok. Did the compiler
>> complain about this to you?
> 
> I remember any * can be assigned directly to void * in ANSI C, but
> void * should be converted to specific point * type. Right?
> 

No.

> And I checked the code of kswapd, in which explicitly conversion is
> taken on the arg *. I think it should do so in journal.c too.
> 

Please check more similar code.
