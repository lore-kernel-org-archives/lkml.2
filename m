Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1CHWOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 17:14:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51810 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab1CHWOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:14:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=voPuQ6XT8q1xeQBYGPqHRURX0jzU5rZR9VSKV/kzVXE6HffnZNzUpcMNyVa7W9eTE/
         r+wlBz/LttrCgDZUvCYW08siphis5hSuMeQZ2Zbk7KZL4gqONgG/4QIXW7ypE4MiKK3E
         Zc2ZXXkv0CdrjoQGQA+jSURXAHoOtVJSZ3oHI=
Message-ID: <4D76AA2C.2010805@gmail.com>
Date: Tue, 08 Mar 2011 23:14:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org> <201103082025.38559.rjw@suse.com> <4D76920A.8070605@gmail.com> <201103082312.26675.rjw@sisk.pl>
In-Reply-To: <201103082312.26675.rjw@sisk.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 11:12 PM, Rafael J. Wysocki wrote:
> On Tuesday, March 08, 2011, Jiri Slaby wrote:
>> On 03/08/2011 08:25 PM, Rafael J. Wysocki wrote:
>>> On Tuesday, March 08, 2011, Jiri Slaby wrote:
>>>> On 02/22/2011 04:36 PM, Alan Stern wrote:
>>>>> By the way, are you booting with no_console_suspend?  And do you do 
>>>>> "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
>>>>> suspending?
>>>>
>>>> Unfortunately there are no messages at all.
>>>>
>>>> Rafael, this is a Factory with intel gfx (modesetting). Do pm-utils
>>>> switch a console in such case? And if yes, to which one?
>>>
>>> pm-utils don't, but s2ram does, I'm not sure from the top of my head to
>>> which one, though.
>>>
>>> If you use a KMS driver (I get you do), please just "chmod a-x /usr/sbin/s2ram".
>>
>> Yeah, I meant kernel modesetting, of course. Sorry for the confusion.
>>
>> I don't have /usr/sbin/s2ram.
> 
> Ah.  So it's gone from Factory?  Interesting.

I don't know, maybe it's in suspend package which I don't have installed.

-- 
js
