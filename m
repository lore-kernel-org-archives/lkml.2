Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab0HOQC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab0HOQC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:02:57 -0400
Date: Sun, 15 Aug 2010 14:03:36 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
Subject: Re: [dm-devel] linux-2.6.35+ causes LVM to fail with "
	device-mapper: version ioctl failed: Inappropriate ioctl for device"
Message-ID: <20100815130336.GA24055@agk-dp.fab.redhat.com>
Mail-Followup-To: Jeff Chua <jeff.chua.linux@gmail.com>,
	device-mapper development <dm-devel@redhat.com>,
	lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com> <20100814155401.GJ26032@agk-dp.fab.redhat.com> <AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just a vanilla linux. No udev.

So likely a userspace problem where udev is now assumed to be present.
 
> > Provide long listing of /dev/mapper and any dm/lvm devices in /dev.

You can do that by running:
  ls -l /dev/mapper /dev/vg01

Also:
  cat /proc/devices
  cat /proc/misc

Alasdair

