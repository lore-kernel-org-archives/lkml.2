Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2KCFkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 01:40:53 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48450 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2KCFkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 01:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <20121102182926.GA18824@kroah.com>
References: <1351836952-3389-1-git-send-email-luca.clementi@gmail.com>
	<20121102182926.GA18824@kroah.com>
Date: Fri, 2 Nov 2012 22:40:51 -0700
Message-ID: <CANqkERC11jHdEpgX=Z+7Fb-5U5xjyEcxEqeEeBcuy8amuvu4PA@mail.gmail.com>
Subject: Re: [PATCH] Staging: Android: logger: module_exit implementationg
From: Brian Swetland <swetland@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Clementi <luca.clementi@gmail.com>, linux-kernel@vger.kernel.org,
        Robert Love <rlove@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 11:29 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 01, 2012 at 11:15:52PM -0700, Luca Clementi wrote:
>> +
>> +
>> +module_init(logger_init);
>
> Is module_init() the same "level" as device_initcall()?  Did you test
> this out in an Android system?
>
>> +module_exit(logger_exit);
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Brian Swetland, <swetland@google.com>");
>> +MODULE_DESCRIPTION("Android Logger");
>> +
>> +
>
> What's with the unneeded trailing empty lines?

Also, module author should be Robert Love (cc'd), unless he'd rather
not be credited, in which case "Google, Inc" or no listed author is
fine.

Brian
