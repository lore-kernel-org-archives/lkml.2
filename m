Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab1ETNVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:21:38 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:9059 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab1ETNVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:21:37 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: vmbus driver
Thread-Topic: vmbus driver
Thread-Index: AQHMFm8184rvumQ7c0KLvy9LhTr6cJSWJaeA//+MsjA=
Date: Fri, 20 May 2011 13:21:36 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481FC2CD@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1305842785-30206-1-git-send-email-kys@microsoft.com>
 <20110520130527.GB10033@kroah.com>
In-Reply-To: <20110520130527.GB10033@kroah.com>
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
> Sent: Friday, May 20, 2011 9:05 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: vmbus driver
> 
> On Thu, May 19, 2011 at 03:06:25PM -0700, K. Y. Srinivasan wrote:
> >
> > Greg,
> >
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
> The merge window is closed now, and I'm on the road in asia for about 3
> weeks, so doing this, at this point in the development cycle, is going
> to be hard.
> 
> I'll go review the bus code again after the code is all merged with
> Linus, which should take a week or so depending on my schedule, and let
> you know what's left to do (I think there still is something wierd with
> the way the hv_driver is structured, but I could be wrong.)

Thanks Greg. I look forward to your feedback.

> 
> In the mean time, I'm sure the block and network driver still need a lot
> of work, and merging the bus code doesn't make much sense without them
> as a user as that is what people really want to use, so you can continue
> to work on them.

I will continue to cleanup the block and network driver code. As you know the
util driver is also a client of the vmbus driver (as far as the communication with 
the host goes). So, it may still make sense to plan for getting the vmbus driver out 
of staging along with the util and the timesource driver. 

Regards,

K. Y

