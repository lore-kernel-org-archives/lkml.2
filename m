Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab0GOIwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:52:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58488 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab0GOIv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <20100715013619.ba473d39.akpm@linux-foundation.org>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org> 
	<20100715035230.GA2186@suse.de> <AANLkTilFLBpQR1BS8WFDXiLSOl08rI9DMpDhdkMXn1st@mail.gmail.com> 
	<20100715013619.ba473d39.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 15 Jul 2010 10:51:34 +0200
Message-ID: <AANLkTim0cri2RqpP7AadlGdw_U-JM81LE-g8BTnb05Ox@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, Jens Axboe <axboe@kernel.dk>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:36, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 15 Jul 2010 10:31:15 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> On Thu, Jul 15, 2010 at 05:52, Greg KH <gregkh@suse.de> wrote:
>> > On Wed, Jul 14, 2010 at 04:38:52PM -0700, Andrew Morton wrote:
>>
>> >> and the box still won't boot.
>> >
>> > Ick, that sucks.
>> >
>> > What kernel was FC6 based on originally?
>> >
>> > Kay, I thought that Fedora had fixed the "can't find root" issue for
>> > this type of sysfs configuation a long time ago. __Or was that something
>> > else for PPC that I am thinking of?
>>
>> It was fixed, and it's weird bug in nash.
>>
>> If Andrew is still doing the same thing as years ago, he does not
>> update the initramfs image, he boots with the old original initramfs
>> along with the new kernel. :)
>
> I run
>
>        VERS=$(make kernelrelease 2>/dev/null)
>        <copy vmlinux>
>        /sbin/new-kernel-pkg --mkinitrd --install

Ah, I see.

It might be, that the fix only hit FC7, or Andrew did not install the
updates. The original mail about the nash problem is here:
  http://lkml.org/lkml/2007/6/7/209

Kay
