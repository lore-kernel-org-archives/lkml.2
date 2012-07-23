Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2GWPbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:31:00 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48797 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753739Ab2GWPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:30:58 -0400
Message-ID: <500D6DF7.3050701@xenotime.net>
Date: Mon, 23 Jul 2012 08:29:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefan Beller <stefanbeller@googlemail.com>
CC: rob@landley.net, jgarzik@pobox.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Rewrite Documentation/SubmittingPatches.
References: <500BAFE0.8070108@googlemail.com> <500BB232.7000108@googlemail.com> <500CD6CC.2000108@xenotime.net> <500CFB59.6040305@googlemail.com>
In-Reply-To: <500CFB59.6040305@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 12:20 AM, Stefan Beller wrote:

> On 07/23/2012 06:45 AM, Randy Dunlap wrote:
> 
>> On 07/22/2012 12:56 AM, Stefan Beller wrote:
>>
>>>   Documentation/SubmittingPatches | 191 ++++++++++++++++++++++++----------------
>>>   1 file changed, 116 insertions(+), 75 deletions(-)
>>>
>>> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
>>> index c379a2a..ac00451 100644
>>> --- a/Documentation/SubmittingPatches
>>> +++ b/Documentation/SubmittingPatches
>>> @@ -163,9 +157,9 @@ Do not send more than 15 patches at once to the vger mailing lists!!!
>>>   Linus Torvalds is the final arbiter of all changes accepted into the
>>> -Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
>>> +Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
>>
>> what are the changes on the line above and below, please?
>>
>>>   He gets a lot of e-mail, so typically you should do your best to -avoid-
>>> -sending him e-mail.
>>> +sending him e-mail.
>>
>>
>>
>> thanks,
>>
> There used to be a whitespace after each of both lines, but my mailprogram removed them, so in
> the actually sent patch they seem to be equal. :/
> 


then you'll probably need to resend the patch so that it will apply
cleanly, but that's up to whoever is going to apply/merge it.


thanks,
-- 
~Randy
