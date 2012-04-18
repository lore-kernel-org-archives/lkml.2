Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2DTHDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:03:44 -0400
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:53855 "EHLO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2DTHDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:03:41 -0400
Message-ID: <4F8F3618.3070706@genband.com>
Date: Wed, 18 Apr 2012 15:46:00 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Subject: Re: "udevadm info --attribute-walk --path=/block/sda" doesn't show
 parents
References: <4F8F3563.9020701@genband.com>
In-Reply-To: <4F8F3563.9020701@genband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2012 21:46:01.0605 (UTC) FILETIME=[A5C08350:01CD1DAC]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18848.002
X-TM-AS-Result: No--19.296600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 03:42 PM, Chris Friesen wrote:
>
> I have a 2.6.34.10-based kernel with udev-161 (also tested with udevadm from udev-173).
>
> When I run "udevadm info --attribute-walk --path=/block/sda" it just shows the device
> itself, and doesn't walk the whole chain showing the parents.
>
> Is there anything I can do, or am I caught with a kernel that isn't properly supported?
> I'm not subscribed to the hotplug list, so cc'ing me would be appreciated.
>
>
> I don't know what's causing the problem, but I find it suspicious that /sys/block/sda
> is a directory rather than a symlink like it is on my 2.6.35.14 laptop.  I'm poking
> around in the udevadm code now.
>
>
> Some possibly-useful information:

I forgot to include this....this might be useful as well:

root@typhoon-base-unit0:/root> udevadm info -q path -n /dev/sda
/block/sda



For comparison, on my 2.6.35.14 laptop I get:


[cfriesen@blah log]$ udevadm info -q path -n /dev/sda
/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
