Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab2EIQGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:06:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab2EIQGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:06:00 -0400
Date: Wed, 9 May 2012 09:05:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        Francois Rigaut <frigaut@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120509160555.GA13437@kroah.com>
References: <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com>
 <20120503233858.GA13453@kroah.com>
 <4FA358ED.1080705@gmail.com>
 <20120504184851.GB11223@kroah.com>
 <CAE9FiQWuePNRWV=ncJkF57aQZ0ZT91xxZ0sZMexq8HgN9NcAfA@mail.gmail.com>
 <CAE9FiQWcyRfLKB+YivOfa-GydbhoaMx06n6a4VMDWoTOMkj7ig@mail.gmail.com>
 <4FA4AA3E.1070903@gmail.com>
 <4FA544B1.3070705@gmail.com>
 <20120505164819.GA21599@schottelius.org>
 <4FA5EE63.1050208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA5EE63.1050208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 11:22:11AM +0800, Jiang Liu wrote:
> I'm afraid it won't work by just changing the OSDW() return value.
> After analysis the ACPI table, I guess the BIOS ACPI implementation doesn't
> confirm to the ACPI specification for hotplug, it needs special support in
> OS to enable Thunderbolt cable hotplug on that system. Maybe that's the
> reason why it's only enabled on Apple's OSes, not sure it's due to technical
> or business considerations.
> 
> This PCIe device "05:00.0 System peripheral: Intel Corporation Device 151a
> (rev 01)" may play a role in the Thunderbolt cable hotplug operations, but
> haven't figured it out yet.

Thanks for looking at this.

So either we need a BIOS update for this platform so that other
operating systems can work properly (i.e. full ACPI hotplug support), or
we write a new hotplug driver to handle this hardware properly.

Intel was rumored to have this working in their labs, I'll poke some
people to see if they have anything they can release...

thanks,

greg k-h
