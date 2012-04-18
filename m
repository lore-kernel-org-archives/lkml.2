Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2DRBT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:19:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60614 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2DRBT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <201204172220.45970.rjw@sisk.pl>
References: <4F8790F6.5080408@intel.com>
	<201204161907.13806.rjw@sisk.pl>
	<CAC=cRTNdLu=A64YAEp78ENc1h2OJKusXY3Wm9LuY4drz9pbomg@mail.gmail.com>
	<201204172220.45970.rjw@sisk.pl>
Date: Wed, 18 Apr 2012 09:19:55 +0800
Message-ID: <CAC=cRTN2QHWu1aD4AGyTB=wuHW-0oyLreZ2QiWSMvf_Ne_Nz0g@mail.gmail.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 4:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, April 17, 2012, huang ying wrote:
>> On Tue, Apr 17, 2012 at 1:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > Moreover, I really don't think it's a good idea to put PCI Express ports into
>> > low-power states in general.  It might work on your platform, whatever it is,
>> > but that doesn't mean it's going to work on every PCI Express system out
>> > there.  I actually know of a number of such systems where it surely won't
>> > work at all.
>>
>> The runtime PM support for PCIe port is not turned on by default, we need
>>
>> # echo auto > /sys/devices/pcixxxx:xx/<pci id>/power/control
>>
>> to turn on it.  And we will turn on it on system it works.  Is this sufficient?
>
> No, it is not.  In some cases it shouldn't be enabled at all for PCI Express
> ports, as far as I can say, so to be on the safe side we should only enable it
> on platforms where PCI Express ports are known to work correctly with runtime PM.

Sorry, I did not catch your idea exactly.  I think disable it by
default and enable it by sysfs interface is what you suggested, isn't
it?  Or you suggest something like "white list"?

Best Regards,
Huang Ying
