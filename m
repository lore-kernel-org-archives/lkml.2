Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2G0T2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:28:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59165 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2G0T2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:28:31 -0400
Message-ID: <5012EBD9.8010602@pobox.com>
Date: Fri, 27 Jul 2012 15:28:25 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] NVMe: Add a character device for each nvme device
References: <1343407458-29909-1-git-send-email-keith.busch@intel.com> <20120727181212.GM22985@linux.intel.com>
In-Reply-To: <20120727181212.GM22985@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 02:12 PM, Matthew Wilcox wrote:
> On Fri, Jul 27, 2012 at 10:44:18AM -0600, Keith Busch wrote:
>> Registers a character device for the nvme module and creates character
>> files as /dev/nvmeN for each nvme device probed, where N is the device
>> instance. The character devices support nvme admin ioctl commands so
>> that nvme devices without namespaces can be managed.
>
> I don't see a problem here, but I'm no expert at sysfs / character devices.
> Alan, Greg, anyone else see any problems with how this character device is
> created / destroyed?

This seems like something normally done via a control device that is 
addressible via bsg.

This is -not- a NAK, but maybe the storage folks have a different 
preference for an admin-command path.

	Jeff


