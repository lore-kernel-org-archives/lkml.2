Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab2BUUmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:42:06 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60468 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab2BUUmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:42:04 -0500
Date: Tue, 21 Feb 2012 15:40:53 -0500 (EST)
Message-Id: <20120221.154053.2103818562080068513.davem@davemloft.net>
To: andrei.emeltchenko.news@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
References: <20120221151435.GA19354@tuxdriver.com>
	<20120221.144417.1445117001833888214.davem@davemloft.net>
	<CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 21 Feb 2012 12:40:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Date: Tue, 21 Feb 2012 22:38:16 +0200

> Hi David,
> 
> On Tue, Feb 21, 2012 at 9:44 PM, David Miller <davem@davemloft.net> wrote:
>> From: "John W. Linville" <linville@tuxdriver.com>
>> Date: Tue, 21 Feb 2012 10:14:36 -0500
>>
>>> On Mon, Feb 20, 2012 at 07:23:24PM -0500, David Miller wrote:
>>>> From: "John W. Linville" <linville@tuxdriver.com>
>>>> Date: Mon, 20 Feb 2012 15:37:40 -0500
>>>>
>>>> > Here is another batch of fixes intended for 3.3.  Most of the fixes
>>>> > this time are for Bluetooth.
>>>>
>>>> Pulled, but please read the bluetooth changes more carefully in the
>>>> future, there were a lot of coding style errors introduced this
>>>> time around.
>>>
>>> I pinged Johan about this, and he tells me that he spoke to Marcel
>>> as well.  They were a bit unsure about the issue.  Is your concern
>>> primarily about some excessive tabbing for indentation of parameters
>>> and such?
>>
>> So you actually looked at the changes you pushed to me and you are
>> telling me you personally can't find anything that looks like garbage?
>>
>> Really?  Do I really have to point out such obvious stuff like this?
>> Are you serious?
>>
>> Look at ca0d6c7ece0e78268cd7c5c378d6b1b610625085 ("Bluetooth: Add
>> missing QUIRK_NO_RESET test to hci_dev_do_close")
>>
>> You tell me what the heck you think of this thing.
>>
>> -       if (!test_bit(HCI_RAW, &hdev->flags)) {
>> +       if (!test_bit(HCI_RAW, &hdev->flags) &&
>> +                               test_bit(HCI_QUIRK_NO_RESET, &hdev->quirks)) {
>>
>> That's disgusting, it jumps off the screen and says "Hello, I am ugly
>> as sin".  How in the world can you miss something like this?  Four
>> TABs on the second line?  Why?  I can't believe we even have to discuss
>> something like this, seriously.
> 
> Sorry did we understand wrong text of Linux coding style? Or do we need
> right interpretation of it?

I'm not engaging in this conversation any more, I don't care what CodingStyle
says, the quoted code is garbage.
