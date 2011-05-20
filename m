Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab1ETNMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:12:41 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:25424 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1ETNMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:12:40 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: vmbus driver
Thread-Topic: vmbus driver
Thread-Index: AQHMFm8184rvumQ7c0KLvy9LhTr6cJSWGtyA//+P+eA=
Date: Fri, 20 May 2011 13:12:32 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481FC2AF@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1305842785-30206-1-git-send-email-kys@microsoft.com>
 <20110520122649.GA550@infradead.org>
In-Reply-To: <20110520122649.GA550@infradead.org>
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
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, May 20, 2011 8:27 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: vmbus driver
> 
> On Thu, May 19, 2011 at 03:06:25PM -0700, K. Y. Srinivasan wrote:
> > A few days ago you applied all the outstanding patches for the Hyper-V
> > drivers. With these patches, I have addressed all of the known review
> > comments for the  vmbus driver (and a lot of comments/issues in other
> > drivers as well). I am still hoping I can address
> > whatever other issues/comments there might be with the intention to
> > get the vmbus driver out of staging in the current window. What is your
> > sense in terms of how feasible this is. From my side, I can assure you
> > that I will address all legitimate issues in a very timely manner and this
> > will not be dependent upon the location of the drivers (staging or
> > outside staging). Looking forward to hearing from you.
> 
> There's no point in merging it without a user.  Make sure either
> the network or storage driver is in a good enough shape to move with it,
> to make sure the APIs it exports are actually sanely usable.

Well, the util driver that implements a range of other services such as KVP, 
time synch, heartbeat etc. is also a client of the vmbus driver (perhaps not in the 
same way as the storage and network drivers). I  was hoping  to
move the util driver out of staging along with the vmbus driver.

On a different note, thanks to the feedback I got from you, Greg and others,
both storage and network drivers are in a much better shape than they ever were.
I will continue to cleanup the storage drivers and I would greatly appreciate your 
feedback and review. 

> 
> On the other hand the HV clocksource looks mostly mergeable and doesn't
> depend on vmbus.  Send a patch to add it to drivers/clocksource to the
> maintainer and it should be mergeable with very little remaining
> cleanup.

Agreed, now that the merge window is closed, I will have to wait for a few weeks.

Regards,

K. Y
 
