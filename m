Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2HZN6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 09:58:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:48718 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab2HZN6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 09:58:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,315,1344236400"; 
   d="scan'208";a="185445015"
Message-ID: <503A2B76.7030808@intel.com>
Date: Sun, 26 Aug 2012 21:58:14 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: gregkh <gregkh@linuxfoundation.org>,
        Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
References: <1331787186.2979.71.camel@debian> <20120315145743.GA7928@kroah.com> <4F6204B7.5010908@intel.com> <20120315175608.GA6077@xanatos> <4FC5D04E.5040907@intel.com> <4FD59AD8.1050109@intel.com> <20120611204709.GC5742@xanatos> <20120611211428.GB24904@kroah.com> <502897A4.4030601@intel.com> <20120826020123.GG6557@xanatos>
In-Reply-To: <20120826020123.GG6557@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2012 10:01 AM, Sarah Sharp wrote:

> On Mon, Aug 13, 2012 at 01:59:00PM +0800, Alex Shi wrote:
>> On 06/12/2012 05:14 AM, gregkh wrote:
>>
>>> On Mon, Jun 11, 2012 at 01:47:09PM -0700, Sarah Sharp wrote:
>>>> Hi Alex,
>>>>
>>>> This got lost in the 3.5 push, but I think it's a good candidate for
>>>> 3.6.  I think Greg is accepting 3.6 patches now, and I'll send this off
>>>> to him.
>>>
>>> Yes, I am taking 3.6 stuff now.  In the future, once -rc1 is out, I can
>>> take patches for the next release at that point in time.
>>>
>>> greg k-h
>>>
>>
>>
>> Didn't find the patch in upstream 3.6-rc, but it is still workable for
>> upstream kernel.
>> So, was you just going to apply it on 3.7 kernel?  or just forget it?
> 
> Hi Alex,
> 
> I am human, and trying my human best to keep up as a maintainer.  Bug
> fixes and big features take priority over the small improvements, and
> I'm sorry that your patch (and other patches) have fallen by the
> wayside.  It is not personal, I simply cannot be perfect.
> 
> I will be returning to full maintainership duties after the various
> Linux conferences next week, and I will do my best to get your patch
> merged.


Thanks for your response, and pick up this small patch.

I am sorry, if you thought I want press you on a such small issue.
Actually, I just went to have a kindly reminder.

Thanks again for your consideration and maintain job!


> 
> Sarah Sharp



-- 
Thanks
    Alex
