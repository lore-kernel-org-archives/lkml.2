Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1BLJ57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 04:57:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab1BLJ5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:57:55 -0500
Message-ID: <4D56593D.1000603@redhat.com>
Date: Sat, 12 Feb 2011 17:56:13 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC Patch] virtio: export model and type in /sys
References: <1296442381-21652-1-git-send-email-amwang@redhat.com> <20110201173738.GA18526@infradead.org> <4D4B9CE3.7080505@redhat.com> <20110212071711.GB18475@infradead.org>
In-Reply-To: <20110212071711.GB18475@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年02月12日 15:17, Christoph Hellwig 写道:
> On Fri, Feb 04, 2011 at 02:29:55PM +0800, Cong Wang wrote:
>>> It does not make any sense to fill this at all in virtio.  The
>>> attributes are simply exporting the SCSI INQUIRY data, and do not make
>>> any sense at all outside a SCSI context.  In fact the type field even
>>> contains numbers from the scsi protocol spec that just don't make sense.
>>>
>>
>> Hmm, so other non-SCSI devices don't have these neither?
>> Do you have any suggestions to find another way to identify a disk?
>
> Many modern disks have uuid strings identifying them, e.g. virtio-blk
> has a serial attribute for it.  For SCSI and ATA they are retreived
> by issuing the commands to get them through the pass through ioctls
> right now, but I'd love to see the serial sysfs attribute implemented
> there as well.

Hmm, looks promising but needs more efforts.

Thanks!
