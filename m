Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2DYPAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:00:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37228 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2DYPAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:00:20 -0400
Message-ID: <4F98117C.7080309@lwfinger.net>
Date: Wed, 25 Apr 2012 10:00:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 32-bit ppc kernel
References: <4F973026.3020103@lwfinger.net>  <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net> <1335327081.21961.28.camel@pasglop>
In-Reply-To: <1335327081.21961.28.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 11:11 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2012-04-24 at 21:37 -0500, Larry Finger wrote:
>>>> Somewhere between v3.2 and v3.3, the kernel in my Powerbook G4
>> started issuing
>>>> the following traceback on bootup:
>>>
>>> Does it continue working afterward or not at all ?
>>>
>>> Are you using the old IDE driver or the newer libata based
>> pata_macio ?
>>
>> Yes, it finishes the boot, and appears to work correctly. If a device
>> is
>> missing, I do not know what it is.
>>
>> I think I am using the old IDE driver.
>>
> Interesting. Does it make a difference if you switch to pata_macio ?

After a few tries, I managed to change over to pata_macio. Fortunately, most of 
the system used dev-by-id or UUID, thus most of the process was getting all the 
kernel pieces built in.

Unfortunately, the original problem remains. I have resumed the bisecting - only 
11 steps to go. I should have it by Friday! :)

Larry
