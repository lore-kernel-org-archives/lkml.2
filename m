Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab2IETi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:38:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48050 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2IETi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:38:57 -0400
Date: Wed, 5 Sep 2012 12:38:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "thozza@redhat.com" <thozza@redhat.com>,
        "dcbw@redhat.com" <dcbw@redhat.com>
Subject: Re: [PATCH 0/4] Tools: hv
Message-ID: <20120905193852.GA412@kroah.com>
References: <1346864519-30020-1-git-send-email-kys@microsoft.com>
 <20120905191119.GA2085@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9309E034B@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9309E034B@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 07:24:37PM +0000, KY Srinivasan wrote:
> > On Wed, Sep 05, 2012 at 10:01:59AM -0700, K. Y. Srinivasan wrote:
> > > This patchset was authored by Ben Hutchings <ben@decadent.org.uk>. Ben
> > > asked me to submit this patchset. This patchset cleans up the KVP daemon
> > > code and fixes some bugs.
> > >
> > >
> > > K. Y. Srinivasan (4):
> > >   tools: hv: Fix file handle leak
> > >   tools: hv: Fix exit() error code
> > >   tools: hv: Check for read/write errors
> > >   tools: hv: Parse /etc/os-release
> > 
> > If Ben wrote these, why are you showing that you wrote them?
> 
> Ben asked me to apply these patches on the tip (of my tree) and send the
> patches out and that is what I did. I recreated these patches after applying to
> my tree and that is what I have sent out. How could I have made the authorship
> more clear (other than noting so in the comment which I have done).

You could have actually _kept_ the proper authorship information so that
git shows who wrote the patch.  As your shortlog shows above, it looks
like you wrote the patches, not Ben, which is not acceptable.

As to how to actually do that, well, I'll leave that as an exercise for
the reader (hint, we document how to do this quite well...)

greg k-h
