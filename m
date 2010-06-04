Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0FDCna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:43:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40101 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab0FDCn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AG16vMkHvjZOrFGdh/xaPU3C8YCG69PeAj5Q66Zu++SWzb7Ax9MSgSZGB2XYTni3kG
         p891PLKT7BBvTfYhbgthRUnqDQG022vYMDjuJILFDrUiLkWwVyeGu3bAw9ydPYTlaqUa
         eNk3Xe50Gs9+dK9jZNM3dOoduKd6byX+c4EvY=
MIME-Version: 1.0
In-Reply-To: <20100603175643.GY8301@sequoia.sous-sol.org>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com> 
	<20100601183920.GB19955@kroah.com> <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com> 
	<AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com> 
	<EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com> 
	<AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com> 
	<20100603175643.GY8301@sequoia.sous-sol.org>
From: Frank Pan <frankpzh@gmail.com>
Date: Fri, 4 Jun 2010 10:43:07 +0800
Message-ID: <AANLkTil7ZIqfdYeNA1dkfIDoKPeWU-FIArR-n-1HjqEz@mail.gmail.com>
Subject: Re: Add a helper function in PCI IOV to get VF device
To: Chris Wright <chrisw@sous-sol.org>
Cc: "Williams, Mitch A" <mitch.a.williams@intel.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> VF is often loaded on the physical machine.  There's also a networking
> specific mechanism for querying and configuring a VF via the PF.
? I don't really understand. What do you mean load? I don't think
physical machine is able to use it as a hardware device.

> While your patch is simple, it's unclear to me what your end goal is.
> The patch itself only adds a function. if you showed how you are
> planning to use it, that would really help.
Currently my hack is applied on 2.6.18 because of xen's limitation. As
Mitch says, igb driver is significantly different with recent ones. On
the other hand, my hack just exposes several PCI configuration and
MMIO registers to the sysfs, you will only understand the use case
when you also see the userspace hacks.

> It's especially confusing that you are comparing your patch with
> symlinks visible in sysfs.
That's my fault. The most recent reply explains it.

Thanks for reply.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
