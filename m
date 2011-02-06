Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab1BFFc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 00:32:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37941 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1BFFc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 00:32:58 -0500
Message-ID: <4D4E32AD.5000102@vflare.org>
Date: Sun, 06 Feb 2011 00:33:33 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: fix data corruption issue
References: <1296956060-13594-1-git-send-email-ngupta@vflare.org> <20110206050059.GA4465@kroah.com> <4D4E2B90.7010109@vflare.org> <20110206051111.GA4816@kroah.com>
In-Reply-To: <20110206051111.GA4816@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2011 12:11 AM, Greg KH wrote:
> On Sun, Feb 06, 2011 at 12:03:12AM -0500, Nitin Gupta wrote:
>> On 02/06/2011 12:00 AM, Greg KH wrote:
>>> On Sat, Feb 05, 2011 at 08:34:20PM -0500, Nitin Gupta wrote:
>>>> In zram_read() and zram_write() we were not incrementing the
>>>> index number and thus were reading/writing values from/to
>>>> incorrect sectors on zram disk, resulting in data corruption.
>>>
>>> Is this something that needs to go into .38 or can it wait until .39?
>>>
>>
>>
>> This really needs to get into .38 or users will see random data
>> corruption on zram devices.
>
> Ok, I'll queue it up for there.  What about .37 and/or .36?
>


The same problem exists on .37 and .36. I just checked that the same 
patch applies cleanly to both these version so may be included in their 
respective maintenance releases.

Thanks,
Nitin
