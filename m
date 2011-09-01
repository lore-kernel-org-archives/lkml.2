Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab1IAU5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 16:57:41 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:8035 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab1IAU5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 16:57:40 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: Hyper-V TODO file
Thread-Topic: Hyper-V TODO file
Thread-Index: AQHMaOYedebhsNSnAEe3RY7o1REvPJU5AUPA
Date: Thu, 1 Sep 2011 20:57:38 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B5C63@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314829011-28922-1-git-send-email-kys@microsoft.com>
 <20110901202733.GA15185@kroah.com>
In-Reply-To: <20110901202733.GA15185@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, September 01, 2011 4:28 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: Hyper-V TODO file
> 
> On Wed, Aug 31, 2011 at 03:16:51PM -0700, K. Y. Srinivasan wrote:
> >
> > Greg,
> >
> > The TODO file for Hyper-V drivers has not been updated in a while and does
> > not reflect the current state of these drivers:
> >
> > 1) There are no more checkpatch warnings/errors in this code. One of the
> TODO
> > work items is "fix remaining checkpatch warnings and errors".
> 
> Great, you can delete it.

Will do.
> 
> > 2) With your help, we have fixed all of the issues related to these drivers
> > conforming to the Linux Device Driver model. One of the TODO work items is
> > "audit the vmbus to verify it is working properly with the driver model".
> 
> I have a few comments about this, I'll respond in another email.
> 
> > 3) Like all other virtualization platforms, the protocol to communicate with
> > the host is very host specific. The ringbuffer control structures are shared
> > between the host and the guest and so, the guest is compelled to follow the
> > mandates of the host. Thus, it is not possible for us to merge the vmbus with
> > other virtual buses in the system. One of the TODO work items is  "see if the
> > vmbus can be merged with the other virtual busses in the kernel".
> 
> Sure, you can delete it.
> 
Will do.
> > 4) A couple of months ago, we had posted the network driver for community
> review.
> > We have submitted patches (and these have been applied) to address the
> review
> > comments. One of the TODO work items is "audit the network driver"
> 
> Leave that until the network subsystem authors agree that this is all
> taken care of by merging the driver into their subsystem.
> 
Ok; will do.

> > 5) Recently, we have merged the IDE and scsi drivers into a single driver that
> > can handle both IDE and SCSI devices. These patches have been already
> checked in.
> > As part of this effort, we have addressed all of the community comments on
> the
> > combined storage driver. The TODO file currently has two work items on this
> > issue: "audit the block driver" and "audit the scsi driver".
> 
> Same as above for the network driver, but you can leave just one entry
> now.

Ok; will do.
> 
> I can't apply patches right now due to the kernel.org infrastructure
> reworking, so you will have to wait a few days for me to apply your
> previous ones, but feel free to send a patch cleaning up the TODO file
> now.

Thanks Greg. I will get the patches out soon.

Regards,

K. Y

