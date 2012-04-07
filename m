Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab2DGA23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:28:29 -0400
Received: from masquerade.micron.com ([137.201.242.130]:24698 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2DGA22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:28:28 -0400
Message-ID: <4F7F8A26.2040707@micron.com>
Date: Fri, 6 Apr 2012 17:28:22 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/5] mtip32xx: Add new sysfs entry 'status' and fix restart
 port
References: <4F7E07DC.50909@micron.com> <20120406011037.GA25892@kroah.com> <4F7F322B.6060805@micron.com> <4F7F615B.80305@micron.com> <20120406214426.GA12772@kroah.com> <4F7F682C.9050806@micron.com> <20120406233004.GA24121@kroah.com>
In-Reply-To: <20120406233004.GA24121@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--12.301200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2012 4:30 PM, Greg KH wrote:

>>> > > What do the existing api files show for block devices?
>>> > > 
>> > 
>> > 
>> > I was looking into sysfs-driver-* files to create sysfs-driver-mtip32xx.
>> > These files have paths like /sys/bus/pci/*, /sys/devices/*,
>> > /sys/class/bluetooth/*, etc.
>> > 
>> > There are sysfs-block-dm and sysfs-block-zram files with
>> > /sys/block/dm-<num>/dm/* and /sys/block/zram<id>/*. If I have to follow
>> > these, then the file would be sysfs-driver-rssd with /sys/block/<disk>/*.
>> > 
>> > Let me know.
> /sys/block/rs*/ would be the right place, right?  You know the tree
> better than I do as you have this hardware and can see where in sysfs
> the files really are :)

Yes, I started that way and found /sys/block/rssda is a sym link to
/sys/devices/pci0000\:00/0000\:00\:01.0/0000\:01\:00.0/block/rssda/.
That is when I got the doubt, is it ok to use the sym link path or
should use the actual path.

I will go ahead with filename sysfs-block-rssd and path
/sys/block/rssd*/<entry>.

Thanks.

--
Regards,
Asai Thambi
