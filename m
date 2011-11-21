Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1KUWma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:42:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:53851 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab1KUWm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:42:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,549,1315206000"; 
   d="scan'208";a="39892885"
Message-ID: <4ECAD3D4.4070306@intel.com>
Date: Mon, 21 Nov 2011 14:42:28 -0800
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Stefan Priebe <s.priebe@profihost.ag>
CC: Stable Tree <stable@kernel.org>, stable@vger.kernel.org,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Jesse Brandeburg <jesse.brandeburg@intel.com> Bruce Allan" 
	<bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Subject: Re: Kernel v3.0.8 igb driver dies when pulling network cable
References: <4ECA4362.2050307@profihost.ag> <4ECA884C.5010706@intel.com> <4ECA936E.8060301@profihost.ag>
In-Reply-To: <4ECA936E.8060301@profihost.ag>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 10:07 AM, Stefan Priebe wrote:
>> You are going to need to clarify some things since as far as I know we
>> never released a v3.0.8 driver, and the kernel in the bug below is a
>> version 2.6.40.8 which sounds more like a modified and possibly
>> backported Linux kernel since as far as I know Linus never released a
>> 2.6.40 kernel version.
> Sorry that my description was so inaccurate. I'm talking about a
> vanilla v3.0.8 linux kernel. Just renamed to 2.6.40.8.
>
>> In order to be able to assist you we will need some additional
>> information.  What Linux distro are your running?  Do you have the
>> latest updates from them?  Also have you tried running the latest
>> out-of-tree driver we provide at e1000.sf.net in order to verify if the
>> same issue occurs with that driver?
> Linux Distri is Debian Lenny but we're running a self compiled vanilla
> 3.0.X kernel. I haven't tried to use the up2date e1000.sf.net driver
> as 3.0 is a long time supported kernel by greg - so all needed fixes
> should be backported or at least send to stable@ so that greg can have
> a look at them.
>
> Thanks!
>
> Stefan
Stefan,

It would be useful if you could try the latest driver from e1000.sf.net
just to verify  if this is a bug in the upstream kernel or if it is also
present in our e1000.sf.net.driver.  This way we can figure out if this
is an issue where a patch wasn't pushed into the stable kernel or if it
is an issue that still exists in our latest release.

Also could you provide us with the part number you are currently using. 
If you could provide us with the device ID for the part via lspci we can
start narrowing down the root cause for the issue as currently we don't
have any information about what hardware you are experiencing this issue on.

Thanks,

Alex
