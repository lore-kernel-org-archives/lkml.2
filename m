Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650Ab2DLAqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:46:36 -0400
Received: from masquerade.micron.com ([137.201.242.130]:8338 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab2DLAqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:46:35 -0400
Message-ID: <4F8625CE.2010902@micron.com>
Date: Wed, 11 Apr 2012 17:46:06 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Greg KH <gregkh@linuxfoundation.org>, Sam Bradshaw <sbradshaw@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
References: <20120411183457.GA19379@kroah.com> <4F85E217.8060406@kernel.dk> <4F85EAA3.7010807@micron.com> <4F85EBDA.1030804@kernel.dk>
In-Reply-To: <4F85EBDA.1030804@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--6.572400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 1:38 PM, Jens Axboe wrote:

> On 2012-04-11 22:33, Asai Thambi S P wrote:
>> On 4/11/2012 12:57 PM, Jens Axboe wrote:
>>
>>> On 2012-04-11 20:34, Greg KH wrote:
>>>> This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
>>>> depend on PCI.
>>>
>>> I think it's an old dependency. I've built and run it here without as
>>> well, and no functional issues either.
>>>
>>> Sam/Asai?
>>>
>>
>>
>> Both driver and device will work fine without PCIe hotplug dependency. This
>> dependency is required for supporting surprise removal and surprise insertion
>> of the device on systems with PCIe hotplug controller.
> 
> That goes for all devices, though. So I think we can safely remove this
> dependency. Nobody should expect hotplug/removal to work, without
> actually including that :-)
> 
> If you or Sam would formally ack the patch, then I'll add it to the
> pending mtip32xx series.
> 

Acked-by: Asai Thambi S P <asamymuthupa@micron.com>

--
Regards,
Asai Thambi
