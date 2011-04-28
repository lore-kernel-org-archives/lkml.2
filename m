Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab1D1Asr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:48:47 -0400
Received: from kroah.org ([198.145.64.141]:59241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab1D1Asf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:48:35 -0400
Date: Wed, 27 Apr 2011 17:28:17 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Message-ID: <20110428002817.GE14294@kroah.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:54:02AM +0000, KY Srinivasan wrote:
> > After that, do you want another round of review of the code, or do
> > you have more things you want to send in (like the name[64] removal?)
> 
> I would prefer that we go through the  review process. What is the process for
> this review?

The same as always, just ask.

> Is there a time window for people to respond.

No.  We don't have time limits here, this is a community, we don't have
deadlines, you know that.

> I am hoping I will be able to address all the review comments well in
> advance of the  next closing of the tree, with the hope of taking the
> vmbus driver out of staging this go around (hope springs eternal in
> the human breast ...)! 

Yes, it would be nice, and I understand your the corporate pressures you
are under to get this done, and I am doing my best to fit the patch
review and apply cycle into my very-very-limited-at-the-moment spare
time.

As always, if you miss this kernel release, there's always another one 3
months away, so it's no big deal in the long-run.

thanks,

greg k-h
