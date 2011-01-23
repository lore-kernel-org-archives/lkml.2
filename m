Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1AWNjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:39:14 -0500
Received: from smtp-out12.han.skanova.net ([195.67.226.212]:50854 "EHLO
	smtp-out12.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758Ab1AWNjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:39:10 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 23 Jan 2011 14:38:57 +0100
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110123133857.GA2641@polaris.bitmath.org>
References: <20110122134513.1e1d512a@stein>
 <20110122200002.GA1677@polaris.bitmath.org>
 <20110122204050.GB22252@ericsson.com>
 <20110122205254.GA2854@polaris.bitmath.org>
 <20110123000016.387cde2c@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123000016.387cde2c@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 12:00:16AM +0100, Stefan Richter wrote:
> On Jan 22 Henrik Rydberg wrote:
> > > I can take it.
> > 
> > Great, thanks.
> > 
> > > Looks pretty straightforward. Do you think it is ready for upstream,
> > > or should I wait for verification ?
> > 
> > I was able to reproduce the problem, but a verification would still be
> > good, just in case - if possible. AFAICT, it will be another week
> > before rc3, so there seems to be no rush.
> 
> With this patch, there is no lockdep warning anymore.  Thanks.

Thank you Stefan. How about a Tested-by, now that I forgot to add a
Reported-by to the patch?

Henrik
