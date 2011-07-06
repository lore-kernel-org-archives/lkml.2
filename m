Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1GFVha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:37:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37889 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1GFVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:37:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6399"; a="102004064"
From: David Brown <davidb@codeaurora.org>
To: Greg KH <gregkh@suse.de>
Cc: Prashant Shah <pshah.mumbai@gmail.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: msm: fixed style issues found by checkpatch.pl
References: <20110706074934.GA935@mail.fossee.in>
	<20110706155745.GB16625@suse.de>
	<CAD6i1fK0nH+D3v+A3erC1PgR=S=709H9ZC=T8-q0gqV1ghA0bQ@mail.gmail.com>
	<20110706192656.GA30532@suse.de>
Date: Wed, 06 Jul 2011 14:37:26 -0700
In-Reply-To: <20110706192656.GA30532@suse.de> (Greg KH's message of "Wed, 6
	Jul 2011 12:26:56 -0700")
Message-ID: <8yay60bytt5.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06 2011, Greg KH wrote:

> On Wed, Jul 06, 2011 at 09:45:08PM +0530, Prashant Shah wrote:
>> Hi,
>> 
>> > So that would be one patch for fixing extra braces, one for extra
>> > spaces, and so on.  That makes it easier to review.
>> 
>> Ok I will redo them.
>> 
>> On Wed, Jul 6, 2011 at 9:27 PM, Greg KH <gregkh@suse.de> wrote:
>> > On Wed, Jul 06, 2011 at 01:19:34PM +0530, Prashant P. Shah wrote:
>> > Also, did you successfully build this code before and after your
>> > changes?
>> 
>> I tried but the code does not build because of #include <mach/board.h>
>> in the msm_fb.c file. I dont know how to fix that.
>
> I say let's just delete this whole directory as if it doesn't build, no
> one is using it, and no one has tried to clean it up since it was
> originally added.
>
> Stepan or David or Abhijeet or Daniel, any objection to just deleting
> drivers/staging/msm/ at this point in time for the 3.1 kernel release?
> You haven't sent any patches to me to clean this code up since the
> original patch, way over a year ago.

I have none.  The non-staging driver has been getting updates, and I
asked the author if it was OK to remove the staging one.  I believe the
real driver supports everything the staging one did.

Should I generate a (large) patch, or is it easier for you to just
remove the tree?

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
