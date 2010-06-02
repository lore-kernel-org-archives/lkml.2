Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0FBGDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:03:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47887 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0FBGDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=c4zQMG4HLh+y8KaVuAZNmdhUiAFUJo0D4VdNmNdqI1mp0oiWb5sQ1Fs9/3Eg2ms8cN
         Rres2zUgHKP0VdIZxJIM5Dp3f7YH0wqxif4zca4VDo+RQkm6SwbUkDSi5cgNHGEZUrXG
         Y2ki4cDCzz98itmH6vqDAKdchbdZ3ZRjS3hqE=
MIME-Version: 1.0
In-Reply-To: <20100601183920.GB19955@kroah.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com> 
	<20100601183920.GB19955@kroah.com>
From: Frank Pan <frankpzh@gmail.com>
Date: Wed, 2 Jun 2010 14:02:50 +0800
Message-ID: <AANLkTim-ivA0jM9Dyn_nodz56vdsQBUbtvtvzXiPYRLj@mail.gmail.com>
Subject: Re: Add a helper function in PCI IOV to get VF device
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       Mitch Williams <mitch.a.williams@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is "VF" and "PF" here?
Virtual function/Physical function

> No, the network core should create that symlink, not the driver, right?
They are not network interfaces, so network core
won't link them. They are for VM uses. I may need
to explain this more clearly.

PF's interface in sysfs is /sys/class/net/ethx, while
VF has no interface. So 82576 driver makes directories
to provide interface-like sysfs entries: /sys/class/net/ethx/vf[1-7]
Make a link to this directory form VF's pci device is
almost impossible, because PF doesn't know VF's bdf.

Thanks for reply.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
