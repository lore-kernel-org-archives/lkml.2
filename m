Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab1CWPQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:16:14 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:36482 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755570Ab1CWPQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:16:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABariU1Ld/sX/2dsb2JhbAAMhDjVSJBigSeBWIFzdwSZPw
X-IronPort-AV: E=Sophos;i="4.63,231,1299474000"; 
   d="scan'208";a="97702680"
Message-ID: <4D8A0EBA.6060202@teksavvy.com>
Date: Wed, 23 Mar 2011 11:16:10 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Herbert Poetzl <herbert@13thfloor.at>, linux-kernel@vger.kernel.org,
        Bernhard Kaindl <bk@suse.de>, Andi Kleen <andi@firstfloor.org>,
        linux-usb@vger.kernel.org
Subject: Re: debugging a modern laptop ...
References: <Pine.LNX.4.44L0.1103231102050.2211-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103231102050.2211-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-23 11:04 AM, Alan Stern wrote:
> On Wed, 23 Mar 2011, Herbert Poetzl wrote:
> 
>>
>> Greetings!
>>
>> I'm trying to evaluate my options on debugging a recent
>> laptop/notebook/table (and the Linux kernel on it of course) 
>> from early bootup to diagnostics when the machine has locked up ...
..
> There _is_ support for a USB console (see CONFIG_USB_SERIAL_CONSOLE).  
> However it may not be useful for diagnosing problems during boot,
> because obviously the console won't operate until the USB stack is in
> place and running.
..

If you are lucky enough to have an ExpressCard slot on the notebook,
then lots of eBay sellers offer "Oxford chipset" serial/parallel ports
in ExpressCard format.

These provide "true" bus serial ports, which can be used as Linux consoles
for low level kernel debugging, logs, panics, etc..

As a bonus, he parallel ports from the same chips can be used
for homebrew JTAG adapters.

-ml
