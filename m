Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2AaTqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:46:20 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52099 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2AaTqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:46:19 -0500
Date: Tue, 31 Jan 2012 14:45:58 -0500 (EST)
Message-Id: <20120131.144558.1534275761422552896.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org, gregkh@suse.de,
        steve.glendinning@smsc.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc95xx: add macaddr module parameter
From: David Miller <davem@davemloft.net>
In-Reply-To: <201201311917.12534.danny.kukawka@bisect.de>
References: <1328030433-12524-1-git-send-email-danny.kukawka@bisect.de>
	<20120131172731.03df5704@pyramind.ukuu.org.uk>
	<201201311917.12534.danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 11:46:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Tue, 31 Jan 2012 19:17:11 +0100

> On Dienstag, 31. Januar 2012, Alan Cox wrote:
>> On Tue, 31 Jan 2012 18:20:33 +0100
>>
>> Danny Kukawka <danny.kukawka@bisect.de> wrote:
>> > Added smsc95xx.macaddr module parameter to allow the user to
>> > change the MAC address on boot if there was no MAC on the EEPROM.
>>
>> NAK. Please see the discussion on this and ifconfig hw for other devices.
>>
>> In summary - make the device refuse to ifconfig up without a valid
>> address, allow it to come into existance without a valid address and then
>> use ifconfig.
>>
>>
>> Your patch also seems to break if there are several attached to a board.
> 
> There are already other kernel driver which allow to override the (hw) MAC 
> address via a module parameter (macaddr): 

Too bad, it's bad precendence and just because we mistakenly let other
drivers do it in the past, it's not an excuse to allow you to make this
mistake too.

This patch will not be applied.
