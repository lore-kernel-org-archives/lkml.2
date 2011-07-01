Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab1GAWF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 18:05:29 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:51603 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab1GAWF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 18:05:28 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4E0E44A4.4000201@tudelft.nl>
Date: Sat, 02 Jul 2011 00:05:24 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc5+ : khubd blocked
References: <yv9k2yk6fasx2kndcq3elqvq.1309537225091@email.android.com> <Pine.LNX.4.44L0.1107011317250.1988-100000@iolanthe.rowland.org> <20110701200800.GB17865@xanatos>
In-Reply-To: <20110701200800.GB17865@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 01-07-11 22:08, Sarah Sharp schreef:
> On Fri, Jul 01, 2011 at 01:19:23PM -0400, Alan Stern wrote:
>> On Fri, 1 Jul 2011, [ISO-8859-1] ?ric Piel wrote:
>>
>>> Sorry, but from a quick look, it seems to not fix the bug.
>>>
>>> I'll try further on Monday.
>>
>> Do you get a similar message from the task watchdog?  The patch should
>> have caused usb_set_interface() to return early, without trying to
>> acquire the mutex that caused the problem before.
>
> I've been able to reproduce this bug with linus/master.  When I apply
> your patch (or at least change the code to match your patch, since I
> don't have those top-level directories), I can successfully unplug and
> replug in a hub with a keyboard and mouse attached to it, with no hangs.
> So I'm not sure why it isn't working for Éric.
Hi,
I've found out it was not the patched kernel that I was tested (but just 
linus/master), due to a mistake in selecting the right kernel in grub. 
So that'd explain why I was still seeing the bug ;-)

Thanks everyone for reacting to this bug so quickly!
Éric
