Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1JIRvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 13:51:01 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:42804 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751996Ab1JIRu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 13:50:59 -0400
Message-ID: <4E91DF00.8060107@xenotime.net>
Date: Sun, 09 Oct 2011 10:50:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: balbi@ti.com
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] usb gadget: fix langwell_udc.c build error
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au> <4E8F67C6.5020603@xenotime.net> <20111008100326.GA24633@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111008100326.GA24633@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 03:03, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Oct 07, 2011 at 01:57:42PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Move function to fix langwell_udc.c build error:
>>
>> drivers/usb/gadget/langwell_udc.c: In function 'show_langwell_udc':
>> drivers/usb/gadget/langwell_udc.c:1693:3: error: implicit declaration of function 'lpm_device_speed'
>> drivers/usb/gadget/langwell_udc.c: At top level:
>> drivers/usb/gadget/langwell_udc.c:2637:37: error: conflicting types for 'lpm_device_speed'
>> drivers/usb/gadget/langwell_udc.c:1693:20: note: previous implicit declaration of 'lpm_device_speed' was here
> 
> I don't have this compile error on my branch, did something go in
> without me noticing ?

probably not.  What version of gcc are you using?
I'm using 4.5.1.

> Can you blame a comit which introduced this ?

I don't see such a commit.

> btw, all I have is a warning.

What warning?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
