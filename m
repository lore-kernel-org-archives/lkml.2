Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031807Ab2COQrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:47:35 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63562 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031918Ab2COQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:47:27 -0400
Message-ID: <4F621D1B.5090709@gmail.com>
Date: Thu, 15 Mar 2012 17:47:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120307 Thunderbird/11.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: stable-3.0: s390 build breakage [was: Linux 3.0.24]
References: <20120312203451.GA16773@kroah.com> <4F61C911.5010204@suse.cz> <4F62186E.4050806@suse.cz> <20120315164624.GB25159@kroah.com>
In-Reply-To: <20120315164624.GB25159@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 05:46 PM, Greg KH wrote:
> On Thu, Mar 15, 2012 at 05:27:26PM +0100, Jiri Slaby wrote:
>> On 03/15/2012 11:48 AM, Jiri Slaby wrote:
>>> On 03/12/2012 09:34 PM, Greg KH wrote:
>>>> I'm announcing the release of the 3.0.24 kernel.
>>> ...
>>>> Heiko Carstens (1): compat: fix compile breakage on s390
>>>
>>> It looks like we need the same fix as for 2.6.32.59:
>>> arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
>>> arch/s390/kernel/setup.c:328: error: 'PSW32_ASC_PRIMARY' undeclared
>>> (first use in this function)
>>> arch/s390/kernel/setup.c:328: error: (Each undeclared identifier is
>>> reported only once
>>> arch/s390/kernel/setup.c:328: error: for each function it appears in.)
>>
>> And when that one is fixed, there is another error:
>> drivers/s390/char/fs3270.c: In function 'fs3270_ioctl':
>> drivers/s390/char/fs3270.c:335: error: implicit declaration of function
>> 'compat_ptr'
>> drivers/s390/char/fs3270.c:335: warning: assignment makes pointer from
>> integer without a cast
> 
> Ick, have a patch for this?

Yes, but give me some time to see if it builds properly now.

thanks,
-- 
js
