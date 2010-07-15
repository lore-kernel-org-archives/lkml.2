Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab0GOIhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:37:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932615Ab0GOIhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:37:36 -0400
Date: Thu, 15 Jul 2010 01:36:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
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
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Message-Id: <20100715013619.ba473d39.akpm@linux-foundation.org>
In-Reply-To: <AANLkTilFLBpQR1BS8WFDXiLSOl08rI9DMpDhdkMXn1st@mail.gmail.com>
References: <20100709185450.GA29473@kroah.com>
	<20100714163852.b3c09930.akpm@linux-foundation.org>
	<20100715035230.GA2186@suse.de>
	<AANLkTilFLBpQR1BS8WFDXiLSOl08rI9DMpDhdkMXn1st@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 10:31:15 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Thu, Jul 15, 2010 at 05:52, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Jul 14, 2010 at 04:38:52PM -0700, Andrew Morton wrote:
> 
> >> and the box still won't boot.
> >
> > Ick, that sucks.
> >
> > What kernel was FC6 based on originally?
> >
> > Kay, I thought that Fedora had fixed the "can't find root" issue for
> > this type of sysfs configuation a long time ago. __Or was that something
> > else for PPC that I am thinking of?
> 
> It was fixed, and it's weird bug in nash.
> 
> If Andrew is still doing the same thing as years ago, he does not
> update the initramfs image, he boots with the old original initramfs
> along with the new kernel. :)

I run

	VERS=$(make kernelrelease 2>/dev/null)
	<copy vmlinux>
	/sbin/new-kernel-pkg --mkinitrd --install 

