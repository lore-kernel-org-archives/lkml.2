Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2GKFEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:04:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38996 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab2GKFD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:03:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120710182804.GA24666@kroah.com>
References: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
	<1341855260-9037-2-git-send-email-devendra.aaru@gmail.com>
	<20120709200604.GA2536@kroah.com>
	<877guc4ryk.fsf@xmission.com>
	<20120710182804.GA24666@kroah.com>
Date: Wed, 11 Jul 2012 10:48:57 +0545
Message-ID: <CAHdPZaNvm8ag1=dCcwsdPJHTA9YxOV0vBZfOLSXy_vRfmXnQUA@mail.gmail.com>
Subject: Re: [PATCH 2/3] staging/slicoss: disable pci device at remove
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 12:13 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>> I haven't see this?  Why don't you want to disable a device at remove
>> time?  Because we put the disable in the generic pci layer?
>
> For some reason, I thought we didn't do this because of other
> "interfaces" on the same card might then be shut down.  But I must have
> been thinking of something else, as lots of drivers do this, so adding
> it here looks to be correct.
>
> So, sorry Devendra, you were right, care to resend this so I can apply
> it?
>

Hi Greg,

I will send the patch out in few hrs, with V2 name.

Actually i was referring to the discussion here in this link,

https://lkml.org/lkml/2005/2/13/82

it says about if the request regions fails we do not disable the
device, as the other driver may be using the device.
since the remove function of the driver is calling, which means that
probe succeeded, so i think its fine to call
pci_disable_device at driver_remove.


> thanks,
>
> greg k-h

Thanks,
devendra.
