Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0G0PCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 11:02:21 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:59649 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469Ab0G0PCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 11:02:20 -0400
Message-ID: <4C4EF4B2.1030404@stericsson.com>
Date: Tue, 27 Jul 2010 17:01:06 +0200
From: Philippe Langlais <philippe.langlais@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>
Subject: Re: patch "U6715 8250 serial like driver" added to gregkh-2.6 tree
References: <1279531660-16317-1-git-send-email-philippe.langlais@stericsson.com>	<12798430773066@site>	<20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>	<4C4E9064.6070001@stericsson.com>	<20100727091408.49d55447@lxorguk.ukuu.org.uk>	<4C4EF132.7090304@stericsson.com> <20100727160533.653fb5c0@lxorguk.ukuu.org.uk>
In-Reply-To: <20100727160533.653fb5c0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/27/10 17:05, Alan Cox wrote:
>> We have such a platform driver, but I can't see anywhere an example of
>> set_termios()
>> or another uart_ops function overriding.
>>      
> The example I referenced shows you how to provide your own
> serial_in/serial_out.
>
> You will need to adjust the 8250 driver to add another function pointer
> and copy it so that you can also override set_termios.
>
> Alan
>    
I try to do that and send a new patch.

Thanks,
Philippe
