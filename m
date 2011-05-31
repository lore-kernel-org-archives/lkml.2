Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab1EaFtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:49:05 -0400
Received: from mail.lang.hm ([64.81.33.126]:55702 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1EaFtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:49:04 -0400
Date: Mon, 30 May 2011 22:48:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Joe Pranevich <jpranevich@gmail.com>
cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0 change listings - Wonderful World of Linux 3.0
In-Reply-To: <BANLkTim7XZKLCRp=ZtRJWhi7k4BzwYpRpg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105302245490.5766@asgard.lang.hm>
References: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com> <BANLkTi=w7VhV2GxKrGGe9dirHcEkwKrDwA@mail.gmail.com> <BANLkTim7XZKLCRp=ZtRJWhi7k4BzwYpRpg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1577133791-1306820938=:5766"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1577133791-1306820938=:5766
Content-Type: TEXT/PLAIN; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT

keep in mind as you are creating this document how it will be misquoted by 
the press (among others)

it undermines credibility to claim features as 'new' that have been around 
for many years. It also hurts to be seen as claiming lots of new stuff and 
how revolutionary 3.0 is when Linus is going out of his way to point how 
how 3.0 is not some big new thing.

If people start getting the idea that 3.0 is revolutionary (and a huge 
list of 'new' features encourages this), they will make it harder for 
people maintaining systems to swtich to it.

David Lang

On Tue, 31 May 2011, Joe Pranevich wrote:

> Date: Tue, 31 May 2011 01:22:49 -0400
> From: Joe Pranevich <jpranevich@gmail.com>
> To: Mike Frysinger <vapier.adi@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Linux 3.0 change listings - Wonderful World of Linux 3.0
> 
> Mike,
>
> Thank you. I appreciate the comments and the corrections. It was a
> marathon weekend and yes, I missed some obvious typos. Thanks.
>
> As far as what is supported and when, my rule has been that if it is
> labeled as "experimental", then it isn't released. So, that accounts
> for why I didn't list NFSd v4 in this doc, even though there is a
> module for it. (I should make this more clear though.) Similarly, I
> *do* list IPv6 as new. It was listed as experimental in v2.6.0, so
> that qualifies it for inclusion here. And finally, I wasn't aware of
> NTFS-on-FUSE. I'm just researching the kernel tree, but I'll
> definitely dig at that and make a note of it. I have made a note of
> the rest for further research. I know I missed things.
>
> As an aside, there are several ways to look at the v3 release. It is
> just a minor rev over v2.6.39 (and I hope I make that clear in the
> doc), but it's also a chance to step back and look at just how far
> Linux has come in little increments over the last seven years. It was
> difficult to get excited over v2.6.12 or v2.6.22... no matter how
> great those releases may have been. But v3 means that we can step back
> and see the whole 2.6 series in perspective. And it looks awfully
> nice.
>
> Joe
>
>
> On Mon, May 30, 2011 at 11:16 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>> On Mon, May 30, 2011 at 15:59, Joe Pranevich wrote:
>>> organizations use virtualization to keep down hardware costs and
>>> reduce downtime do to system failures. Linux 3.0 significantly
>>
>> "do to" -> "due to"
>>
>>> monitoring chipsets for fault recognition, temperature management, and
>>> similar. This grants server administrators more visibility into their
>>> gear and can help prevent crashes.
>>
>> not sure this helps prevent crashes.  perhaps "helps mitigate downtime" ?
>>
>>> encryption keys that are required for this and other encryption
>>> subssytems.
>>
>> subsystems
>>
>>> On the network side, Linux now supports a new caching add-on for
>>> network filesystems. This allows the OS to create and manage a local
>>> on-disk cache of a remote NFS or CIFS filesystem, decreasing latency
>>> while being fully transparent to the end-user.
>>
>> i dont think it is limited to remote filesystems
>>
>>> Linux also now supports
>>> NFSv4, the fourth version of the venerable Network Filesystem as a
>>> client. However, Linux only supports running NFSv3 as a server.
>>
>> what about CONFIG_NFSD_V4 ?  that looks like NFSv4 as a server to me ...
>>
>>> While Linux 3.0 still has difficulty accessing NTFS volumes (the
>>> default on modern versions of Windows), support for mounting Windows
>>> network shares has been significantly improved.
>>
>> with ntfs3g (built on FUSE), i dont think this is an accurate
>> statement.  even if your focus is purely on in-kernel fs's, this is at
>> least a bit misleading.
>>
>>> In conjunction with an internal sensor, this
>>> feature can mean the difference between a nasty look at a pet or loved
>>> one or a nasty look at a pet or loved one followed by a trip to the
>>
>> i think the first "or" on this last line should be an "and"
>>
>>> devices. Linux also supports (or will support, when the hardware is
>>> generally available) the Tile processors designed by Tilera in Silicon
>>> Valley. They massively multi-core processors have a unique split
>>> between functionality of general-purpose processors and more specific
>>
>> "They massively" -> "The massively"
>>
>>> processing such as would be done on a GPU. Other new supported
>>> processors include the Microblaze, S+core, Blackfin, Atmel, and the
>>> 64-bit version of the Super-H.
>>
>> i dont think "Atmel" is an architecture.  i think you meant "AVR32".
>>
>>> Perhaps the most noteworthy feature addition in Linux 3.0 is the
>>> inclusion of IPv6.
>>
>> i'm pretty sure at least Linux 2.4 had support for IPv6.
>>
>>> Two other core network features are worthy of note. First, the Linux
>>> network subsystem has been made considerably faster on multi-processor
>>> systems. Unlike under Linux 2.6, incoming network traffic on different
>>> interfaces can now be handled on multiple CPUs. This will ensure that
>>> Linux can deal with multiple high-throughput network devices with less
>>> latency.
>>
>> i think there's also support for multi transmit ?  or has that not
>> been merged yet ?
>>
>>> And second, the Linux wireless driver system has been
>>> completely rewritten. In addition to just supporting many new devices,
>>> these devices are now supported in a more uniform way and with more
>>> features available on more of the cards. Key here are improvements to
>>> the low-level Ethernet implementation (including a complete software
>>> stack where necessary), QoS support, and others.
>>
>> the inclusion of the soft mac80211 stuff is pretty note worthy
>>
>>> or monitored. WiMax is also new in Linux 3.0. This technology, with
>>> the correct hardware, allows for joining wide area wireless networks
>>
>> "correct" is a bit awkward.  how about "right" ?
>>
>>> Device Busses
>>
>> buses
>>
>>> An unsung hero, device busses are the way that peripherals (both
>>
>> buses
>>
>>> One major advancement since the launch of Linux 2.6 has been the
>>> emergence of the PCI Express Bus. PCI Express, sometimes called PCI-E,
>>
>> "called" -> "referred to as"
>>
>>> such as hot-plugging. Support for external busses has also
>>
>> buses
>>
>>> that comply with the USB3 specification) as well as many other drivers
>>
>> USB 3.0
>>
>>> Firewire, another type of serial bus common in video processing and
>>> other environments, has also be improved in Linux 3.0 with the
>>
>> "be" -> "been"
>>
>>> hardware. Now stable in Linux 3.0 is ?USB On-The-Go?, the device side
>>
>> might be useful to include "OTG" in here
>>
>>> communicate with a host which speaks the USB protocol. A similar
>>> system, though not used in home computing, is the ?Controller Area
>>> Network?.
>>
>> definitely would be useful to have "CAN" in here
>>
>>> This system is primarily used in automotive and military
>>> computing when multiple devices want to communicate with each other
>>> without the presence of a ?host? computer to orchestrate.
>>
>> one of the other major reasons for CAN is robustness is the high noise
>> automative/military world
>> -mike
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
--680960-1577133791-1306820938=:5766--
