Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab1LOTS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:18:27 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54296 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab1LOTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:18:25 -0500
Message-ID: <4EEA47FD.4050407@pobox.com>
Date: Thu, 15 Dec 2011 14:18:21 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: balbi@ti.com, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Kevin Cernekee <cernekee@gmail.com>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v2] ahci: platform support for suspend/resume
References: <1321643410-16102-1-git-send-email-computersforpeace@gmail.com> <20111118192809.GF11736@legolas.emea.dhcp.ti.com> <CAN8TOE-yZyHC3n+dSu9wZ=UBmenD67OHbAyrF2K_sgf0O7oUJA@mail.gmail.com>
In-Reply-To: <CAN8TOE-yZyHC3n+dSu9wZ=UBmenD67OHbAyrF2K_sgf0O7oUJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 01:13 PM, Brian Norris wrote:
> On Fri, Nov 18, 2011 at 11:28 AM, Felipe Balbi<balbi@ti.com>  wrote:
>> On Fri, Nov 18, 2011 at 11:10:10AM -0800, Brian Norris wrote:
>>> Add platform hooks for custom suspend() and resume() functions. The
>>> generic suspend/resume code in drivers/ata/ahci_platform.c is adapted
>>> from the PCI version in drivers/ata/ahci.c.
>>>
>>> Signed-off-by: Brian Norris<computersforpeace@gmail.com>
>>
>> Reviewed-by: Felipe Balbi<balbi@ti.com>
>
> Thanks for the review, Felipe.
>
> What's the status on this? There have been no comments for almost a
> month. Can it be merged?

The previous version was queued, but did not apply to upstream (I 
emailed a comment at the time).  Hopefully this one works...



