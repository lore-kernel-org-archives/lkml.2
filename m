Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2EJBtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:49:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56090 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2EJBth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:49:37 -0400
Message-ID: <4FAB1EAF.2090305@gmail.com>
Date: Thu, 10 May 2012 11:49:35 +1000
From: Francois Rigaut <frigaut@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jiang Liu <liuj97@gmail.com>,
        Nico Schottelius <nico-linux-20120419@schottelius.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
References: <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com> <20120503233858.GA13453@kroah.com> <4FA358ED.1080705@gmail.com> <20120504184851.GB11223@kroah.com> <CAE9FiQWuePNRWV=ncJkF57aQZ0ZT91xxZ0sZMexq8HgN9NcAfA@mail.gmail.com> <CAE9FiQWcyRfLKB+YivOfa-GydbhoaMx06n6a4VMDWoTOMkj7ig@mail.gmail.com> <4FA4AA3E.1070903@gmail.com> <4FA544B1.3070705@gmail.com> <20120505164819.GA21599@schottelius.org> <4FA5EE63.1050208@gmail.com> <20120509160555.GA13437@kroah.com>
In-Reply-To: <20120509160555.GA13437@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I went ahead and contacted John Ronciak at intel.
He gave a presentation on thunderbolt at the 2011 linux plumber conference.
Here is his answer:

"You are correct that most if not all issues related to Thunderbolt on 
Linux is due to BIOS problems. We have not seen anything other BIOS 
issues regarding Thunderbolt issues on Linux. When the BIOS is working 
correctly the hot-plug PCIe works fine wrt the kernel. These are things 
that cannot be fixed in the drivers or in kernel infrastructure. So 
newer systems are going to be better than older ones due to these BIOS 
issues."

Francois

On 10/05/12 02:05, Greg KH wrote:
> On Sun, May 06, 2012 at 11:22:11AM +0800, Jiang Liu wrote:
>> I'm afraid it won't work by just changing the OSDW() return value.
>> After analysis the ACPI table, I guess the BIOS ACPI implementation doesn't
>> confirm to the ACPI specification for hotplug, it needs special support in
>> OS to enable Thunderbolt cable hotplug on that system. Maybe that's the
>> reason why it's only enabled on Apple's OSes, not sure it's due to technical
>> or business considerations.
>>
>> This PCIe device "05:00.0 System peripheral: Intel Corporation Device 151a
>> (rev 01)" may play a role in the Thunderbolt cable hotplug operations, but
>> haven't figured it out yet.
> Thanks for looking at this.
>
> So either we need a BIOS update for this platform so that other
> operating systems can work properly (i.e. full ACPI hotplug support), or
> we write a new hotplug driver to handle this hardware properly.
>
> Intel was rumored to have this working in their labs, I'll poke some
> people to see if they have anything they can release...
>
> thanks,
>
> greg k-h
