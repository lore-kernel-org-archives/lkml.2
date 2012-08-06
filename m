Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2HFQET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:04:19 -0400
Received: from imp03.mtu.ru ([62.5.255.20]:60017 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab2HFQER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:04:17 -0400
X-Spam-Flag: NO
Message-ID: <501FEA29.1030400@pavlinux.ru>
Date: Mon, 06 Aug 2012 20:00:41 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120713 Thunderbird/10.0.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH] ACPI: replace strlen("string") with sizeof("string")
 -1
References: <Pine.LNX.4.44L0.1208061028160.1649-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208061028160.1649-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

06.08.2012 18:36, Alan Stern пишет:
> On Mon, 6 Aug 2012, Pavel Machek wrote:
>
>> On Thu 2012-07-26 21:39:38, Len Brown wrote:
>>> ...both give the number of chars in the string
>>> without the '\0', as strncmp() wants,
>>> but sizeof() is compile-time.
>>
>> What about introducing something like streq() to do this
>> automatically? This is ugly....
>>
>> #define streq(a, b) ... if (_buildin_constant(b)) ...
>>
>> ?
>>
>>> -	if (!strncmp(val, "enable", strlen("enable"))) {
>>> +	if (!strncmp(val, "enable", sizeof("enable") - 1)) {
>
> While you're at it, there's no point using strncmp when you know the
> length of one of the strings beforehand.  Just use memcmp, and don't
> subtract 1 from the sizeof value.

http://www.gossamer-threads.com/lists/engine?do=post_attachment;postatt_id=41157;list=linux

:)




-- 

                                                          Pavel.
