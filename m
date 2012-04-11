Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab2DKUdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:33:50 -0400
Received: from masquerade.micron.com ([137.201.242.130]:61402 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2DKUdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:33:49 -0400
Message-ID: <4F85EAA3.7010807@micron.com>
Date: Wed, 11 Apr 2012 13:33:39 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Greg KH <gregkh@linuxfoundation.org>, Sam Bradshaw <sbradshaw@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
References: <20120411183457.GA19379@kroah.com> <4F85E217.8060406@kernel.dk>
In-Reply-To: <4F85E217.8060406@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--2.037900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 12:57 PM, Jens Axboe wrote:

> On 2012-04-11 20:34, Greg KH wrote:
>> This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
>> depend on PCI.
> 
> I think it's an old dependency. I've built and run it here without as
> well, and no functional issues either.
> 
> Sam/Asai?
> 


Both driver and device will work fine without PCIe hotplug dependency. This
dependency is required for supporting surprise removal and surprise insertion
of the device on systems with PCIe hotplug controller.

--
Regards,
Asai Thambi
