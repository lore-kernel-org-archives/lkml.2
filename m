Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1IMQcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:32:22 -0400
Received: from lucidpixels.com ([72.73.18.11]:50668 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab1IMQcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:32:21 -0400
Date: Tue, 13 Sep 2011 12:32:20 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jon Mason <mason@myri.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        Alan Piszcz <ap@solarrain.com>, NetDEV list <netdev@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: 3.1-rc4: spectacular kernel errors / filesystem crash
In-Reply-To: <CAMaF-rMxTWRAO7WRdYoEM57k66MC6Vuwk1mcfgCgMO6Z+KBvzQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1109131156050.7113@p34.internal.lan>
References: <alpine.DEB.2.02.1109110511250.8626@p34.internal.lan> <CAEuXFEzs1f7n5taYzupux3AtKmRcY4P0m7yjkUQA8aLyS8eujw@mail.gmail.com> <1315886706.2556.11.camel@edumazet-laptop> <alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
 <CAMaF-rN-qeXBDoc9=7kwu40Wj8=G8YuPKWXPRhOuhdYX_VO34w@mail.gmail.com> <alpine.DEB.2.02.1109131142010.7113@p34.internal.lan> <CAMaF-rMxTWRAO7WRdYoEM57k66MC6Vuwk1mcfgCgMO6Z+KBvzQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Sep 2011, Jon Mason wrote:

> On Tue, Sep 13, 2011 at 10:42 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>>
>> On Tue, 13 Sep 2011, Jon Mason wrote:
>>
>>> On Tue, Sep 13, 2011 at 9:54 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
>>> wrote:
>>>>
>>>>
>>>> On Tue, 13 Sep 2011, Eric Dumazet wrote:
>>>>

Thanks,

# patch -p1 < ../0001-Fix-pointer-dereference-before-call-to-pcie_bus_conf.patch
patching file arch/x86/pci/acpi.c
patching file drivers/pci/hotplug/pcihp_slot.c
patching file drivers/pci/probe.c
# patch -p1 < ../0002-PCI-Remove-MRRS-modification-from-MPS-setting-code.patch
patching file drivers/pci/pci.c
patching file drivers/pci/probe.c
#

Rebooted & running with new patches for 3.1-rc4.
Will let you know if any further issues, I wonder if this will fix
the RCU/SLAB issues too, thanks.

Justin.
