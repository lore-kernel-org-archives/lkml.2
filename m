Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1DEOVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:21:44 -0400
Received: from ftp.sofha.de ([82.144.60.99]:51131 "EHLO ftp.sofha.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1DEOVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:21:43 -0400
Message-ID: <4D9B2575.4030205@snafu.de>
Date: Tue, 05 Apr 2011 16:21:41 +0200
From: Oncaphillis <oncaphillis@snafu.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Xiaofan Chen <xiaofanc@gmail.com>, libusb-devel@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Libusb-devel] Kernel bug message and missing data on libusb_interrupt_transfer
References: <Pine.LNX.4.44L0.1104051013100.1972-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104051013100.1972-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 04:13 PM, Alan Stern wrote:
> On Tue, 5 Apr 2011, Oncaphillis wrote:
>
>> Now I get
>>
>> <snip>
>> ------------[ cut here ]------------
>> kernel BUG at mm/slub.c:2808!
>> invalid opcode: 0000 [#2] SMP
> Can you duplicate this using either a 2.6.37 or 2.6.38 kernel?
>
> Alan Stern
>
The highest kernel version we've tried (as far as i remember) was the
2.6.36. Have there been issues which might have been solved betwen 36 
and 3(7|8) ?

I'll give it a try.

O.



