Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab0EMQVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:21:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab0EMQVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:21:03 -0400
Message-ID: <4BEC26E2.1020404@redhat.com>
Date: Thu, 13 May 2010 13:20:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: mmotm 2010-05-11-18-20 uploaded
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org> <6195.1273763194@localhost> <20100513160249.GC22238@core.coreip.homeip.net>
In-Reply-To: <20100513160249.GC22238@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Thu, May 13, 2010 at 11:06:34AM -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Tue, 11 May 2010 18:21:22 PDT, akpm@linux-foundation.org said:
>>> The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>> Dell Latitude E6500, x86_64 kernel.
>>
>> Boots to single user prompt, but has issues on the way there.  Possibly
>> very important - I was definitely *not* typing at the time (as I had hit
>> return on the LUKS passphrase for the disk at 36 seconds after boot, and
>> I didn't get the # prompt for single-user for another minute or two (probably
>> due to udev having issues due to the oops). So I have no idea what it was
>> trying to get a keycode for...
>>
> 
> Udev probably tries to remap special keys on your keyboard...
> 
>> [   40.717136] udev: starting version 154
>> [   41.710153] BUG: unable to handle kernel NULL pointer dereference at (null)
>> [   41.711007] IP: [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
>> [   41.711007] PGD 11d318067 PUD 118af1067 PMD 0
>> [   41.711007] Oops: 0002 [#1] PREEMPT SMP
>> [   41.711007] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4/idVendor
>> [   41.711007] CPU 0
>> [   41.711007] Modules linked in:
>> [   41.711007]
>> [   41.711007] Pid: 2501, comm: keymap Not tainted 2.6.34-rc7-mmotm0511 #2 0X564R/Latitude E6500
>>
>> [   41.711007] RIP: 0010:[<ffffffff813bb996>]  [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
> 
> I think this is Mauro's big keycode additions.

Yes, it is likely. It may be caused by some bad conflict resolution between both git trees.
I'll handle this bug.

-- 

Cheers,
Mauro
