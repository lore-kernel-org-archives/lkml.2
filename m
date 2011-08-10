Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1HJOnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:43:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33210 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1HJOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:43:23 -0400
Message-ID: <4E429907.6080000@gmail.com>
Date: Wed, 10 Aug 2011 16:43:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110729 Thunderbird/6.0
MIME-Version: 1.0
To: Andreas Bombe <aeb@debian.org>
CC: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/6] TTY: serial, remove BTM from wait_until_sent
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz> <20110719003503.GA4138@amos.fritz.box> <4E3FE2D2.5020801@gmail.com> <20110810010933.GA4733@amos.fritz.box>
In-Reply-To: <20110810010933.GA4733@amos.fritz.box>
X-Enigmail-Version: 1.3a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 03:09 AM, Andreas Bombe wrote:
> On Mon, Aug 08, 2011 at 03:21:22PM +0200, Jiri Slaby wrote:
>> On 07/19/2011 02:35 AM, Andreas Bombe wrote:
>>> On Thu, Jul 14, 2011 at 02:35:10PM +0200, Jiri Slaby wrote:
>>>> This should also fix the issue Andreas is seeing (BTM in comparison to
>>>> BKL doesn't have any hidden functionality like unlocking during
>>>> sleeping).
>>>
>>> I tested the patch series and it does not appear to make a difference
>>> for the internal (16550A) serial ports on my system. Also, I am still
>>> unclear on why it freezes the X display during the timeout period.
>>
>> Sorry for the delay. Could you attach output of sysrq-t when this
>> happens? I mean with a kernel patched by my patch.
> 
> I did my simple test on ttyS0 again: "stty -F /dev/ttyS0 crtscts" then
> "echo >/dev/ttyS0". I attached the gzipped sysrq-t list in case you need
> the complete output. This is just the process while it is trying to
> close the device (bash's internal echo):

Hmm, perhaps obvious question. What is the port connected with? And with
what cable? Is it null modem cable? Or at least with DTR-CTS connected?

thanks,
-- 
js
