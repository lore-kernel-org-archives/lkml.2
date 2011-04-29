Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab1D2O0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:26:18 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:39983 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab1D2O0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:26:16 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Topic: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Index: AQHMBGnbOdiUysHbTUGr026Sn7cwwZRw2pzQgAIIP4CAAfzqoA==
Date: Fri, 29 Apr 2011 14:26:13 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD5AA@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110428002817.GE14294@kroah.com>
In-Reply-To: <20110428002817.GE14294@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, April 27, 2011 8:28 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
> 
> On Wed, Apr 27, 2011 at 01:54:02AM +0000, KY Srinivasan wrote:
> > > After that, do you want another round of review of the code, or do
> > > you have more things you want to send in (like the name[64] removal?)
> >
> > I would prefer that we go through the  review process. What is the process for
> > this review?
> 
> The same as always, just ask.
> 
> > Is there a time window for people to respond.
> 
> No.  We don't have time limits here, this is a community, we don't have
> deadlines, you know that.

Perhaps I did not properly formulate my question here. The review
process itself may be open-ended, and that is fine - we will fix all legitimate
issues/concerns  in our drivers whether they are in the staging area or not. 
My question was specifically with regards to the review process that may gate exiting
staging. I am hoping to re-spin the remaining patches of the last patch-set and send it to
you by early next week and ask for a review. I fully intend to address whatever review 
comments I may get in a very timely manner. Assuming at some point in time after I ask
for this review there are no outstanding issues, would that be sufficient to exit staging?  

> 
> > I am hoping I will be able to address all the review comments well in
> > advance of the  next closing of the tree, with the hope of taking the
> > vmbus driver out of staging this go around (hope springs eternal in
> > the human breast ...)!
> 
> Yes, it would be nice, and I understand your the corporate pressures you
> are under to get this done, and I am doing my best to fit the patch
> review and apply cycle into my very-very-limited-at-the-moment spare
> time.

Greg, I do appreciate your ongoing  help here.

Regards,

K. Y 

