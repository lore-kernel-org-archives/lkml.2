Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2HGJwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:52:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34904 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab2HGJwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:52:00 -0400
MIME-Version: 1.0
X-Originating-IP: [202.62.83.106]
In-Reply-To: <5020DB0B.8070103@suse.cz>
References: <CANYdXnqCY+Uc=ROvQHv4kRe-g2zoEjfpzV0P83exfXYm-qCBaA@mail.gmail.com>
	<1344327969.20004.2.camel@localhost>
	<5020DB0B.8070103@suse.cz>
Date: Tue, 7 Aug 2012 15:21:56 +0530
Message-ID: <CANYdXnq1HVpLFZBND=2HextPXCLC5SkewsAqZFhY0KWzWi+rCw@mail.gmail.com>
Subject: Re: A question on serial driver
From: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Dan Luedtke <mail@danrl.de>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code is a bit unclean to send directly. But any information like
"does driver change modes once it prompts for login"
can be helpful for debugging since my code does not seem to work after login .

Behaviour : Driver prints charecter untill devel login on console. It
accepts characters before login prompt but doesnot accept the
charecters after it prompts for login. I enter the username and it is
not displayed.

On Tue, Aug 7, 2012 at 2:38 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 08/07/2012 10:26 AM, Dan Luedtke wrote:
>> On Tue, 2012-08-07 at 13:52 +0530, Shashidhar Hiremath wrote:
>>> The driver for some reason does not
>>> print the content  I type on console after login prompt. Any reason
>>> why this might be happening ?
>>
>> I don't know if it is just me, but a code snippet might help
>> understanding what happens in your driver.
>
> Yea, without that we can barely help you.
>
> regards,
> --
> js
> suse labs



-- 
regards,
Shashidhar Hiremath
