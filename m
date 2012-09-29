Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2I2NCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 09:02:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45041 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2I2NCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 09:02:15 -0400
Message-ID: <5066F156.8030302@gmail.com>
Date: Sat, 29 Sep 2012 15:02:14 +0200
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

I know this is not a very constructive reply, but these days I am so
busy that I just cannot find the time apply kernel patches :(

I would love to do that, indeed! In the good old days, I would even hack
the UDMI module in the kernel when my new notebook's
drive interface was not recognized, but I am afraid I must resign myself
to missing this entertainment now and in the
foreseeable future.

I posted this bug because I thought if kernel 3.6 goes out with it, that
would be a very bad impression for us, mortal
end-users.

Best wishes,

Gabor

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

