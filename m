Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2GWHVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:21:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47207 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2GWHVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:21:01 -0400
Message-ID: <500CFB59.6040305@googlemail.com>
Date: Mon, 23 Jul 2012 09:20:57 +0200
From: Stefan Beller <stefanbeller@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: rob@landley.net, jgarzik@pobox.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Rewrite Documentation/SubmittingPatches.
References: <500BAFE0.8070108@googlemail.com> <500BB232.7000108@googlemail.com> <500CD6CC.2000108@xenotime.net>
In-Reply-To: <500CD6CC.2000108@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 06:45 AM, Randy Dunlap wrote:

> On 07/22/2012 12:56 AM, Stefan Beller wrote:
>
>>   Documentation/SubmittingPatches | 191 ++++++++++++++++++++++++----------------
>>   1 file changed, 116 insertions(+), 75 deletions(-)
>>
>> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
>> index c379a2a..ac00451 100644
>> --- a/Documentation/SubmittingPatches
>> +++ b/Documentation/SubmittingPatches
>> @@ -163,9 +157,9 @@ Do not send more than 15 patches at once to the vger mailing lists!!!
>>   Linus Torvalds is the final arbiter of all changes accepted into the
>> -Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
>> +Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
>
> what are the changes on the line above and below, please?
>
>>   He gets a lot of e-mail, so typically you should do your best to -avoid-
>> -sending him e-mail.
>> +sending him e-mail.
>
>
>
> thanks,
>
There used to be a whitespace after each of both lines, but my mailprogram removed them, so in
the actually sent patch they seem to be equal. :/

