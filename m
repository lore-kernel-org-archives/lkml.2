Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1DVT2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 15:28:44 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:6685 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1DVT2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 15:28:34 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Greg KH <greg@kroah.com>
CC: "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 05/22] Staging: hv: Get rid of the forward declaration
	of blkvsc_init_rw()
Thread-Topic: [PATCH 05/22] Staging: hv: Get rid of the forward declaration
	of blkvsc_init_rw()
Thread-Index: AQHMAIYOfrKf1nHUWUeyu7gnidQXJpRqRUwA
Date: Fri, 22 Apr 2011 19:28:33 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481CCDF9@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
	<1302125720-10808-1-git-send-email-kys@microsoft.com>
	<1302125720-10808-5-git-send-email-kys@microsoft.com>
	<20110420203506.GA15317@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481CCC12@TK5EX14MBXC126.redmond.corp.microsoft.com>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481CCC12@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.75]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel-bounces@linuxdriverproject.org [mailto:devel-
> bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Thursday, April 21, 2011 8:41 PM
> To: Greg KH
> Cc: Abhishek Kane (Mindtree Consulting PVT LTD); Haiyang Zhang;
> gregkh@suse.de; linux-kernel@vger.kernel.org; virtualization@lists.osdl.org;
> devel@linuxdriverproject.org
> Subject: RE: [PATCH 05/22] Staging: hv: Get rid of the forward declaration of
> blkvsc_init_rw()
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Wednesday, April 20, 2011 4:35 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > Abhishek Kane (Mindtree Consulting PVT LTD)
> > Subject: Re: [PATCH 05/22] Staging: hv: Get rid of the forward declaration of
> > blkvsc_init_rw()
> >
> > On Wed, Apr 06, 2011 at 02:35:03PM -0700, K. Y. Srinivasan wrote:
> > > Get rid of the forward declaration of blkvsc_init_rw() by moving the
> > > code around.
> >
> > This patch fails to apply:
> >
> > Applying: Staging: hv: Get rid of the forward declaration of blkvsc_init_rw()
> > error: patch failed: drivers/staging/hv/blkvsc_drv.c:1000
> > error: drivers/staging/hv/blkvsc_drv.c: patch does not apply
> > Patch failed at 0005 Staging: hv: Get rid of the forward declaration of
> > blkvsc_init_rw()
> >
> > So I'll stop at this patch in the series.
> 
> As I look at the git log in today's tree,
> the topmost patch of mine that is applied is:
> 
> Staging: hv: Get rid of blkvsc_check_events()
> 
> This is a patch that is not even in the patch-set that you were currently
> applying. On April 6th, I sent three patch-sets (all these 3 were resends
> after the tree opened):
> 
> 0000-Staging-hv-Cleanup-storage-drivers-phase-II-fixup: This was a two patch
> series to
> fix-up some bugs. This has been applied.
> 
> 0000-Staging-hv-Cleanup-storage-drivers-phase-III: This was a 22 patch-set of
> which you applied 4 patches and the application of the fifth caused a failure
> (as noted by you in this mail).
> 
> 0000-Staging-hv-Cleanup-storage-drivers-phase-IV: This was a 22 patch set
> That should have been applied last.
> 
> For some reason, after you applied 4 patches from the second set,
> looking at the git log, it looks like a patch from the third set was
> applied:
> 
> Subject: [PATCH 01/22]  Staging: hv: Get rid of blkvsc_check_events()
> 
> This is the reason why
> [PATCH 05/22] Staging: hv: Get rid of the forward declaration of blkvsc_init_rw()
> failed to apply. I am curious if I did something wrong that might have caused
> this problem.
> 
> With regards to rectifying this problem, if you can roll-back that last patch
> that was applied out of order, then I think everything should apply just
> fine. If this is not possible, I would need to re-spin the 40 odd patches
> that currently fail to apply.

Greg,

I am pretty much done with spinning up the patches that are yet to be
applied with against this morning's tree. I will be sending them to you
shortly.

Regards,

K. Y
