Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1EaDQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 23:16:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65094 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1EaDQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 23:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t0P+2wBjn8CpRHAA9mtWD5CuHYJccwh+6YTscwtVneAnXNkDXc1vJBuNK+jb6O2iui
         GJkB02omdD2iAcnsUiT7WE6b9QROiEFEFFefp+Pv28W8Jr/fwOU6TNjc1Luk6+3LVNAV
         uSOOtuEpn9w8XwKCXRYX/VuauFEXIf2rqs7QQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com>
References: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 30 May 2011 23:16:02 -0400
Message-ID: <BANLkTi=w7VhV2GxKrGGe9dirHcEkwKrDwA@mail.gmail.com>
Subject: Re: Linux 3.0 change listings - Wonderful World of Linux 3.0
To: Joe Pranevich <jpranevich@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 15:59, Joe Pranevich wrote:
> organizations use virtualization to keep down hardware costs and
> reduce downtime do to system failures. Linux 3.0 significantly

"do to" -> "due to"

> monitoring chipsets for fault recognition, temperature management, and
> similar. This grants server administrators more visibility into their
> gear and can help prevent crashes.

not sure this helps prevent crashes.  perhaps "helps mitigate downtime" ?

> encryption keys that are required for this and other encryption
> subssytems.

subsystems

> On the network side, Linux now supports a new caching add-on for
> network filesystems. This allows the OS to create and manage a local
> on-disk cache of a remote NFS or CIFS filesystem, decreasing latency
> while being fully transparent to the end-user.

i dont think it is limited to remote filesystems

> Linux also now supports
> NFSv4, the fourth version of the venerable Network Filesystem as a
> client. However, Linux only supports running NFSv3 as a server.

what about CONFIG_NFSD_V4 ?  that looks like NFSv4 as a server to me ...

> While Linux 3.0 still has difficulty accessing NTFS volumes (the
> default on modern versions of Windows), support for mounting Windows
> network shares has been significantly improved.

with ntfs3g (built on FUSE), i dont think this is an accurate
statement.  even if your focus is purely on in-kernel fs's, this is at
least a bit misleading.

> In conjunction with an internal sensor, this
> feature can mean the difference between a nasty look at a pet or loved
> one or a nasty look at a pet or loved one followed by a trip to the

i think the first "or" on this last line should be an "and"

> devices. Linux also supports (or will support, when the hardware is
> generally available) the Tile processors designed by Tilera in Silicon
> Valley. They massively multi-core processors have a unique split
> between functionality of general-purpose processors and more specific

"They massively" -> "The massively"

> processing such as would be done on a GPU. Other new supported
> processors include the Microblaze, S+core, Blackfin, Atmel, and the
> 64-bit version of the Super-H.

i dont think "Atmel" is an architecture.  i think you meant "AVR32".

> Perhaps the most noteworthy feature addition in Linux 3.0 is the
> inclusion of IPv6.

i'm pretty sure at least Linux 2.4 had support for IPv6.

> Two other core network features are worthy of note. First, the Linux
> network subsystem has been made considerably faster on multi-processor
> systems. Unlike under Linux 2.6, incoming network traffic on different
> interfaces can now be handled on multiple CPUs. This will ensure that
> Linux can deal with multiple high-throughput network devices with less
> latency.

i think there's also support for multi transmit ?  or has that not
been merged yet ?

> And second, the Linux wireless driver system has been
> completely rewritten. In addition to just supporting many new devices,
> these devices are now supported in a more uniform way and with more
> features available on more of the cards. Key here are improvements to
> the low-level Ethernet implementation (including a complete software
> stack where necessary), QoS support, and others.

the inclusion of the soft mac80211 stuff is pretty note worthy

> or monitored. WiMax is also new in Linux 3.0. This technology, with
> the correct hardware, allows for joining wide area wireless networks

"correct" is a bit awkward.  how about "right" ?

> Device Busses

buses

> An unsung hero, device busses are the way that peripherals (both

buses

> One major advancement since the launch of Linux 2.6 has been the
> emergence of the PCI Express Bus. PCI Express, sometimes called PCI-E,

"called" -> "referred to as"

> such as hot-plugging. Support for external busses has also

buses

> that comply with the USB3 specification) as well as many other drivers

USB 3.0

> Firewire, another type of serial bus common in video processing and
> other environments, has also be improved in Linux 3.0 with the

"be" -> "been"

> hardware. Now stable in Linux 3.0 is “USB On-The-Go”, the device side

might be useful to include "OTG" in here

> communicate with a host which speaks the USB protocol. A similar
> system, though not used in home computing, is the “Controller Area
> Network”.

definitely would be useful to have "CAN" in here

>This system is primarily used in automotive and military
> computing when multiple devices want to communicate with each other
> without the presence of a “host” computer to orchestrate.

one of the other major reasons for CAN is robustness is the high noise
automative/military world
-mike
