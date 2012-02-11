Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2BKTIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:08:34 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51142 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751335Ab2BKTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:08:33 -0500
Message-ID: <4F36BC92.2000105@xenotime.net>
Date: Sat, 11 Feb 2012 11:08:02 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] usb: add missing Kconfig UWB select to USB_WHCI_HCD and
 USB_HWA_HCD
References: <1328857675.7327.8.camel@marge.simpson.net>	 <4F3541AE.50807@xenotime.net> <20120210181116.GA19806@kroah.com> <1328939004.7340.21.camel@marge.simpson.net>
In-Reply-To: <1328939004.7340.21.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 09:43 PM, Mike Galbraith wrote:
> On Fri, 2012-02-10 at 10:11 -0800, Greg Kroah-Hartman wrote: 
>> On Fri, Feb 10, 2012 at 08:11:26AM -0800, Randy Dunlap wrote:
>>> On 02/09/2012 11:07 PM, Mike Galbraith wrote:
>>>> usb: add missing Kconfig UWB select to USB_WHCI_HCD and USB_HWA_HCD
>>>>
>>>> cripts/kconfig/conf --oldconfig Kconfig
>>>> warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
>>>> warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
>>>> warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
>>>> warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
>>>>
>>>> Signed-off-by: Mike Galbraith <efault@gmx.de>
>>>
>>> I have 2 patches in linux-next that fix the UWB/WUSB problems by using "depends on"
>>> instead...
>>
>> Yes, this should all now be resolved, Mike can you verify this please?
> 
> Nah, Randy surely did, and it would be hard to mess it up ;-)

Hah.  It took me two simple patches to get it right AFAIK.  :(

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
