Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1HZE2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 00:28:43 -0400
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:42067 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1HZE2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 00:28:42 -0400
X-SMTPDoctor-Processed: csmtpprox 2.7.4
MIME-Version: 1.0
In-Reply-To: <20110825155456.4784f16d@lxorguk.ukuu.org.uk>
References: <CAHzZGEz3EYuQQA0BK0Z9L14BXzuYRV4WVHS+6=L9rBwx+_G_8A@mail.gmail.com>
	<20110825155456.4784f16d@lxorguk.ukuu.org.uk>
Date: Fri, 26 Aug 2011 06:28:40 +0200
Message-ID: <CAHzZGEzxm4K6vo8srHjjmgbXiwk9xHsn6hF02sQnZ3vfOZQCzQ@mail.gmail.com>
Subject: Re: Problem with writing virtual serial device driver.
From: =?UTF-8?B?RGF3aWQgQ2nEmcW8YXJraWV3aWN6?= <dawidc@b-labs.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/25 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> The first question would be what error code you get when you try and open
> your new device, that would tell you much, and help identify your problem.

I don't get any error. I can open the device with minicom and
everything appears to be fine but non of ops registered for the device
get's called -- the device is not doing anything. The "dbg()" calls
that I've put all around are not being triggered. The only time dbg()
is printed is init function, which is successful.

I have no clue what can be wrong. As the device is purly virtual I
leave a lot of fields in the original structure empty so this might be
a problem, but how do I know which ones should I fill with some dummy
values? (if this would be a problem of course).

-- 
Dawid Ciężarkiewicz
B-Labs. http://b-labs.com/
