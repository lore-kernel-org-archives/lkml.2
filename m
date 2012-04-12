Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697Ab2DLHjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:39:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53083 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2DLHjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:39:43 -0400
Message-ID: <4F86865A.3030204@kernel.dk>
Date: Thu, 12 Apr 2012 09:38:02 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Sam Bradshaw <sbradshaw@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
References: <20120411183457.GA19379@kroah.com> <4F85E217.8060406@kernel.dk> <4F85EAA3.7010807@micron.com> <4F85EBDA.1030804@kernel.dk> <4F8625CE.2010902@micron.com>
In-Reply-To: <4F8625CE.2010902@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 02:46 AM, Asai Thambi S P wrote:
> On 4/11/2012 1:38 PM, Jens Axboe wrote:
> 
>> On 2012-04-11 22:33, Asai Thambi S P wrote:
>>> On 4/11/2012 12:57 PM, Jens Axboe wrote:
>>>
>>>> On 2012-04-11 20:34, Greg KH wrote:
>>>>> This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
>>>>> depend on PCI.
>>>>
>>>> I think it's an old dependency. I've built and run it here without as
>>>> well, and no functional issues either.
>>>>
>>>> Sam/Asai?
>>>>
>>>
>>>
>>> Both driver and device will work fine without PCIe hotplug dependency. This
>>> dependency is required for supporting surprise removal and surprise insertion
>>> of the device on systems with PCIe hotplug controller.
>>
>> That goes for all devices, though. So I think we can safely remove this
>> dependency. Nobody should expect hotplug/removal to work, without
>> actually including that :-)
>>
>> If you or Sam would formally ack the patch, then I'll add it to the
>> pending mtip32xx series.
>>
> 
> Acked-by: Asai Thambi S P <asamymuthupa@micron.com>

Thanks applied Gregs patch - I see the two of you battled it out while I
was sound asleep ;-)

-- 
Jens Axboe

