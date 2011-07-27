Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1G0RRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:17:37 -0400
Received: from lucidpixels.com ([72.73.18.11]:39849 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab1G0RRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:17:35 -0400
Date: Wed, 27 Jul 2011 13:17:35 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Ruediger Meier <sweet_f_a@gmx.de>
cc: Bryan Schumaker <bjschuma@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
In-Reply-To: <201107271900.11091.sweet_f_a@gmx.de>
Message-ID: <alpine.DEB.2.02.1107271316140.1451@p34.internal.lan>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan> <alpine.DEB.2.02.1107271227340.1451@p34.internal.lan> <4E303F6F.8010706@netapp.com> <201107271900.11091.sweet_f_a@gmx.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jul 2011, Ruediger Meier wrote:

> On Wednesday 27 July 2011, Bryan Schumaker wrote:
>> On 07/27/2011 12:28 PM, Justin Piszcz wrote:
>>> On Wed, 27 Jul 2011, J. Bruce Fields wrote:
>>>>
>>>> What filesystem on the server are you exporting?
>>>
>>> xfs.
>>> /dev/sda1 on / type xfs (rw,noatime)
>>>
>>> Nothing special, thoughts?
>>
>> Are there a lot of files in the directory you're exporting?  It looks
>> like cookie 10272 is mapped to multiple files.
>
> I thought xfs is immune to readdir loops!?
> Is your export directory really located directly within / on /dev/sda1?

Hi,

I was sharing out a directory on the NFS server:
/d1         192.168.0.0/24(async,rw,no_root_squash,no_subtree_check,fsid=1)

Should I share out / instead?
Is this a known problem?

$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1              30G   13G   18G  43% /
tmpfs                 2.0G  8.0K  2.0G   1% /lib/init/rw
udev                   10M  192K  9.9M   2% /dev
tmpfs                 2.0G     0  2.0G   0% /dev/shm
$

Justin.


