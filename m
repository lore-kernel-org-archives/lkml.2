Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0IQQtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:49:12 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:47056 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab0IQQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:49:11 -0400
Message-ID: <4C939BFC.2080008@euromail.se>
Date: Fri, 17 Sep 2010 18:49:00 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Add a hid quirk for input sync override
References: <1282640084-19217-1-git-send-email-rydberg@euromail.se>  <alpine.LNX.2.00.1009011252450.26813@pobox.suse.cz>  <4C7E39CC.80402@euromail.se> <alpine.LNX.2.00.1009021630000.26813@pobox.suse.cz> <D154A68C-ABA2-4C6C-B7E1-C0989357B8F7@enac.fr>
In-Reply-To: <D154A68C-ABA2-4C6C-B7E1-C0989357B8F7@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Owe7S-00026I-5K.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Owe7S-00026I-5K 0a5c517fd4855dcc83e0bdc3e0563a74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 06:20 PM, Stéphane Chatty wrote:

>>>
>>>
>>> Sounds good. I suppose Stephane wants to have a say regarding the 3m driver
>>> first, but no rush. What version are you targeting?
>>
>> 2.6.37 looks reasonable if everything it agreed upon in the following
>> week(s).
>>
> 
> After many adventures, I finally managed to get the driver *and* the 3M panel
> available at the same time. XDS and the satellite events did not help :-)
> 
> I'm observing a few things that look strange with evtest, starting with missing
> ABS_MT_SLOT at the beginning of interaction sequences.


ABS_MT_SLOT will only be emitted when it actually changes, i.e., not necessarily
between frames.

> Investigating... Henrik,
> would it be useful if I send you evtest logs, what I did with my fingers and
> what I find strange in the result?


Certainly. Have you encountered anything strange in the actual interaction with
the device? I have been running the 3M patches daily for several weeks and found
no issues.

Cheers,
Henrik
