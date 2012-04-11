Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab2DKUiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:38:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43902 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2DKUiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:38:55 -0400
Message-ID: <4F85EBDA.1030804@kernel.dk>
Date: Wed, 11 Apr 2012 22:38:50 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Sam Bradshaw <sbradshaw@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
References: <20120411183457.GA19379@kroah.com> <4F85E217.8060406@kernel.dk> <4F85EAA3.7010807@micron.com>
In-Reply-To: <4F85EAA3.7010807@micron.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-11 22:33, Asai Thambi S P wrote:
> On 4/11/2012 12:57 PM, Jens Axboe wrote:
> 
>> On 2012-04-11 20:34, Greg KH wrote:
>>> This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
>>> depend on PCI.
>>
>> I think it's an old dependency. I've built and run it here without as
>> well, and no functional issues either.
>>
>> Sam/Asai?
>>
> 
> 
> Both driver and device will work fine without PCIe hotplug dependency. This
> dependency is required for supporting surprise removal and surprise insertion
> of the device on systems with PCIe hotplug controller.

That goes for all devices, though. So I think we can safely remove this
dependency. Nobody should expect hotplug/removal to work, without
actually including that :-)

If you or Sam would formally ack the patch, then I'll add it to the
pending mtip32xx series.

-- 
Jens Axboe

