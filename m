Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1BKVav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:30:51 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:8204 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab1BKVau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:30:50 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>, KY Srinivasan <kys@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 1/3]: Staging: hv: Use native page allocation/free
 functions
Thread-Topic: [PATCH 1/3]: Staging: hv: Use native page allocation/free
 functions
Thread-Index: AQHLyhRG+iGS6ar1cEyXWS7ZOiGYHJP9JUiAgAAo0wCAAAfOAP//evew
Date: Fri, 11 Feb 2011 21:30:49 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56233F93ED0@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <1297447140-21777-1-git-send-email-kys@microsoft.com>
 <20110211182949.GA10751@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E0B2653@tk5ex14mbxc106.redmond.corp.microsoft.com>
 <20110211212352.GA10845@suse.de>
In-Reply-To: <20110211212352.GA10845@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de] On Friday, February 11, 2011 1:24 PM
> On Fri, Feb 11, 2011 at 08:55:56PM +0000, KY Srinivasan wrote:
> > > I'm not saying this patch is wrong at all, but I still don't
> > > understand why this is different depending on the architecture of
> > > the machine.  Why is this necessary, it should be ok to do the same
> > > type of allocation no matter what the processor is, right?
> >
> > You are right Greg; I don't think there is a need to specify different
> > page protection bits based on the architecture - PAGE_KERNEL_EXEC
> should be enough.
> 
> I thought so, but for some reason Hank said there this was needed.
> Hank, is it still true?

I recall we did it for older versions of Linux but I do not recall why. 
Something from way before 2.6.18, the reason of which I seem to have
Purged due to age :)

> 
> > However, this is the code that is currently in the tree - refer to osd.c.
> 
> Oh, I remember, it's not a critique of this patch, it just reminded me of this
> question I always had for this code.
> 
> > If it is ok with you, I could submit an additional patch to clean this up.
> 
> If Hank says it is ok, and you all test it to verify nothing breaks, please send it
> on.

If you could accept the patch as is and I will work with Ky to see if nothing breaks
If we change this part to what you are suggesting? If nothing breaks we will submit
A followup patch to remove those lines.

Hank.

