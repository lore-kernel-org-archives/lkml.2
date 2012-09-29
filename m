Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab2I2PtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 11:49:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54919 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab2I2Ps6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 11:48:58 -0400
Message-ID: <50671869.5080104@gmail.com>
Date: Sat, 29 Sep 2012 17:48:57 +0200
From: Gabor Takacs <gbrtakacs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: PROBLEM: kernel 3.6.rc6 bug report (usb 3.0 external hard drive
 problem)
References: <20120928141639.GH5368@mwanda> <Pine.LNX.4.44L0.1209281026470.1518-100000@iolanthe.rowland.org> <20120928214709.GA7260@xanatos>
In-Reply-To: <20120928214709.GA7260@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sarah,

got some time off work, for the sake of those good old days...

Don's patch worked, it sees now the device and I can mount both
partitions (one dos, the other ext4) on it :)

The kernel I applied the pacth to was the openSuSE Factory 64-bit
3.6.0-rc7-1-desktop kernel. (Actually I just read
the patch and manually edited the source code).

Thanks very much, and good work to you all for the sake of all of us users!

Best wishes, Gabor

On 09/28/2012 11:47 PM, Sarah Sharp wrote:
> On Fri, Sep 28, 2012 at 10:27:43AM -0400, Alan Stern wrote:
>> On Fri, 28 Sep 2012, Dan Carpenter wrote:
>>
>>> I've filed a bug for this.
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=48061
>>>
>>> Probably the other information which would be useful is the output
>>> from lsusb.  Anyway, I've added the USB list to the CC.
>>>
>>> regards,
>>> dan carpenter
>>>
>>> On Sun, Sep 23, 2012 at 05:33:44PM +0200, Gabor Takacs wrote:
>>>> Bug report for kernel version 3.6.rc6
>>>>
>>>> Content of message:
>>>>
>>>> - One-line description
>>>> - Full description
>>>> - Keywords
>>>> - CPU info
>>>> - Modules info
>>>> - Kernel version
>>>> - Loaded driver and hardware information
>>>> - PCI information
>>>> - SCSI information
>>>>
>>>> One-line description: Western Digital My Passport USB 3.0 hard drive not
>>>> handled by kernel
>>>>
>>>> Full description: under 3.6.rc6 kernel on an Asus Zenbook Prime UX21A,
>>>> when plugging in my
>>>> Western Digital My Passport USB 3.0 hard drive, the system does not
>>>> mount it. It worked with
>>>> previous (3.4.x) kernels.
>> If this failure is reliable then git bisection would be a good way to 
>> pin down the source of the problem.
> This looks awfully like Don Zickus' issue with his WD hard drive:
>
> http://marc.info/?l=linux-usb&m=134886294107752&w=2
>
> But LPM was added in 3.4, so I don't know why 3.4.x kernels worked.
> Gabor, does the patch in that mail fix your issue with the WD drive?
>
> Sarah Sharp


-- 
Gabor Takacs

