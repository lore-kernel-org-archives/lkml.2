Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab2CWTLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:11:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27335 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab2CWTLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:11:24 -0400
MIME-Version: 1.0
Message-ID: <042daf29-3991-4db6-bfe0-36ddc04c22f2@default>
Date: Fri, 23 Mar 2012 12:10:40 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Konrad Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org
Subject: RE: [GIT PULL] staging: ramster: unbreak my heart
References: <2d2c494d-64e3-4968-a406-a8ede7eb39bb@default>
 <20120323164848.GB22875@kroah.com>
In-Reply-To: <20120323164848.GB22875@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4F6CCAD7.00A6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Subject: Re: [GIT PULL] staging: ramster: unbreak my heart
> 
> On Fri, Mar 23, 2012 at 09:40:15AM -0700, Dan Magenheimer wrote:
> > Hey Greg  --
> >
> > The just-merged ramster staging driver was dependent on a cleanup patch in
> > cleancache, so was marked CONFIG_BROKEN until that patch could be
> > merged.  That cleancache patch is now merged (and the correct SHA of the
> > cleancache patch is 3167760f83899ccda312b9ad9306ec9e5dda06d4 rather than
> > the one shown in the comment removed in the patch below).
> >
> > So remove the CONFIG_BROKEN now and the comment that is no longer true...
> >
> > Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> Why do you say "GIT PULL" here, when this is just a single patch?  Odd.

Doh! Sorry, I was going to do a git tree, then realized a simple
patch would be better, then never went back to change the subject.
Sorry for the odd-ness.  Just a brain fart on my part.
 
> I'll queue this up for sending to Linus after 3.4-rc1 is out, thanks.

Great, thanks!

Dan
