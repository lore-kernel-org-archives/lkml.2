Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2ADUlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:41:02 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46750 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab2ADUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:40:59 -0500
Message-ID: <4F04B957.3000408@suse.cz>
Date: Wed, 04 Jan 2012 21:40:55 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: markh@compro.net
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <dmarkh@cfl.rr.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: tty  TTY_HUPPED anomaly
References: <4EF49579.9040907@compro.net> <4EF4CC92.5090502@compro.net> <20111223204015.541924f2@pyx> <4F047767.5060708@compro.net> <20120104162745.76fc3852@pyramind.ukuu.org.uk> <4F04A187.2050705@compro.net> <4F04B65D.6070505@suse.cz> <4F04B7FF.5010906@compro.net>
In-Reply-To: <4F04B7FF.5010906@compro.net>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 09:35 PM, Mark Hounschell wrote:
> On 01/04/2012 03:28 PM, Jiri Slaby wrote:
>> On 01/04/2012 07:59 PM, Mark Hounschell wrote:
>>>> I would guess (given the distro change is the trigger) that you've
>>>> got a
>>>> SuSE problem not a kernel one. The kernel behaviour and code looks
>>>> correct. My guess therefore is that newer SuSE is running stuff in the
>>>> boot which is probing serial ports and messing with the carrier wrongly
>>>> and in ways it didn't use to. That would fit the fact that something
>>>> similarly broken has apparently also appeared in the Fedora user space
>>>> bootup.
>>
>> And we (suse) have a report for enterprise, that says ModemManager
>> causes a similar issue. Could you perhaps check whether you have that
>> thing installed?
>>
>> thanks,
> 
> Yep. ModemManager-0.5-3.1.3.i586

And what happens if you remove that?

-- 
js
suse labs
