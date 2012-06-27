Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2F0I6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:58:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26354 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2F0I6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:58:18 -0400
Date: Wed, 27 Jun 2012 11:58:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: ksummit-2012-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Ksummit-2012-discuss] [ATTEND] Your upstream maintainer just
 isn't that into you...
Message-ID: <20120627085800.GA3007@mwanda>
References: <CAA9_cmeNagC1sF54BAHa1sTzL3sMD3eKoftHQHCM5q9vKq5Dyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmeNagC1sF54BAHa1sTzL3sMD3eKoftHQHCM5q9vKq5Dyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 06:44:56PM -0700, Dan Williams wrote:
> Can we do a better job of bounding the maximum latency for acceptance
> or rejection of a patch?

I sent quite a few patches all over the kernel as part of my Smatch
work.  If I don't get feedback on my patch then I assume it will be
merged.  I've gone through my sent-mail box and collected the
patches which weren't merged.  Hopefully, this is useful in
discussing maintainer submitter feedback.

Some of these patches are probably wrong but it would have been nice
to get some feedback on that.

The SCSI subsystem obviously stands out as pretty bad.  It's the
only subsystem where you can send a patch over and over and not get
a response.  It's not that I think all my patches should be merged
without any review and free hugs for everyone...  For all the other
patches in this list, I feel that the patches was dropped by
mistake but in SCSI it was silently ignored as a policy.

Causes of patches being lost:
* Poor changelog on a cleanup patch.
* I didn't CC the person who introduced the bug so I never got
  their acked-by.
* The patch wasn't obvious and the maintainer was planning to review
  it later and forgot.
* Confusion about who was supposed to pull a patch.
* Poor communication between the maintainer and me and I didn't
  realize they wanted me to redo the patch.  Don't phrase your
  statements as questions.

regards,
dan carpenter

