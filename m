Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2DZLwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 07:52:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32269 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2DZLwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 07:52:13 -0400
Date: Thu, 26 Apr 2012 14:54:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix bug where kfree is called twice.
Message-ID: <20120426115459.GE6447@mwanda>
References: <1335394498-5046-1-git-send-email-rgujare@ozmodevices.com>
 <20120426063858.GC6447@mwanda>
 <4F990AE0.8040400@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F990AE0.8040400@ozmodevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 09:44:16AM +0100, Rupesh Gujare wrote:
> Hi Dan,
> >It's a good patch and it fixes a bug, but could you resend with
> >the subject:
> >
> >[PATCH] Staging: ozwpan: Fix bug where kfree is called twice.
> Sorry about subject line. I should have spend a bit more time in
> formatting subject line.
> However it looks like Greg have already pulled this patch in
> staging-next branch.
> (Thanks Greg, for modifying subject line. I will be more careful next time.)
> 
> However, I will be happy if you still want me to resend this patch
> with correct subject line.
> 

Obviously don't resend.  *eyeroll*  I'll never ask you to resend
stuff just because I'm on a power trip.

> >We don't like to put a lot of bureaucracy infront of people
> >submitting actual bugfixes.  But you guys are the new maintainers
> >and you're going to need to know all this stuff eventually.  Also
> >could you give us a hint how likely the users are to hit this?
> >Should this go into 3.4 or only 3.5?
> I would have loved to get this patch in 3.4 as I am observing
> occasional crashes.
> However looks like Greg have queued it up for 3.5.

Everything goes into linux-next first.  That should have been put
in the changelog.  "We are seeing occasional crashes under load" or
whatever...  It's Greg's call and all, but generally it can't hurt
to ask nicely if you want stuff merged it into 3.4 as well.  ;)

regards,
dan carpenter

