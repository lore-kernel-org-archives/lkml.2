Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2B2F43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 00:56:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2B2F40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 00:56:26 -0500
Date: Tue, 28 Feb 2012 23:56:22 -0600 (CST)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@happy
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Input: atkbd - Add force relese key quirk for HP
 ProBook
In-Reply-To: <20120229010311.GA11492@core.coreip.homeip.net>
Message-ID: <alpine.DEB.2.02.1202282351510.5366@happy>
References: <1330475770-4153-1-git-send-email-manoj.iyer@canonical.com> <1330475770-4153-2-git-send-email-manoj.iyer@canonical.com> <20120229004604.GB21093@kroah.com> <20120229010311.GA11492@core.coreip.homeip.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitry,

This quirk helps a few HP ProBooks to make brightness keys typematic. Can 
you please tell me why you think its better handling this in user space? I 
see other quirks similar to this in atkbd, just trying to understand. Yes, 
we did quirk this in udev rules to make brightness keys works as expected. 
But thought it might help others who see this issue with HP ProBooks by 
quirking it in kernel.

Thanks
Manoj



On Tue, 28 Feb 2012, Dmitry Torokhov wrote:

> On Tue, Feb 28, 2012 at 04:46:04PM -0800, Greg KH wrote:
>> On Tue, Feb 28, 2012 at 06:36:10PM -0600, Manoj Iyer wrote:
>>> HP ProBooks do not send a key release for brightness keys, as a
>>> result, brightness does not move up/down when the brightness key
>>> is held down. This quirk makes the brightness keys on HP ProBooks
>>> typematic.
>>>
>>> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>>> ---
>>>  drivers/input/keyboard/atkbd.c |   16 ++++++++++++++++
>>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>
>> <formletter>
>>
>> This is not the correct way to submit patches for inclusion in the
>> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
>> for how to do this properly.
>>
>> </formletter>
>
> Also, this should be handled from userspace by having usev write to
> /sys/bus/serio/devices/serioX/force_release attribute on affected boxes.
>
> -- 
> Dmitry
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
