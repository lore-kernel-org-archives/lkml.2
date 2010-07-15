Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab0GOIbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:31:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46105 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab0GOIbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:31:38 -0400
MIME-Version: 1.0
In-Reply-To: <20100715035230.GA2186@suse.de>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org> 
	<20100715035230.GA2186@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 15 Jul 2010 10:31:15 +0200
Message-ID: <AANLkTilFLBpQR1BS8WFDXiLSOl08rI9DMpDhdkMXn1st@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
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

On Thu, Jul 15, 2010 at 05:52, Greg KH <gregkh@suse.de> wrote:
> On Wed, Jul 14, 2010 at 04:38:52PM -0700, Andrew Morton wrote:

>> and the box still won't boot.
>
> Ick, that sucks.
>
> What kernel was FC6 based on originally?
>
> Kay, I thought that Fedora had fixed the "can't find root" issue for
> this type of sysfs configuation a long time ago.  Or was that something
> else for PPC that I am thinking of?

It was fixed, and it's weird bug in nash.

If Andrew is still doing the same thing as years ago, he does not
update the initramfs image, he boots with the old original initramfs
along with the new kernel. :)

It might be, that just dropping the entire initramfs, and let the
kernel mount the rootfs, has a good chance to boot the box.

Kay
