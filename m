Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0HSVwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:52:35 -0400
Received: from imr3.ericy.com ([198.24.6.13]:56331 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0HSVwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:52:24 -0400
Date: Thu, 19 Aug 2010 14:51:24 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>,
        Huaxu Wan <huaxu.wan@intel.com>
Subject: Re: [lm-sensors] [PATCH] drivers/hwmon/coretemp: Remove warnings
 of unused variables
Message-ID: <20100819215124.GA8097@ericsson.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
 <1282172027-640-2-git-send-email-fenghua.yu@intel.com>
 <20100819092423.00f76256@hyperion.delvare>
 <4C6D8026.2060800@zytor.com>
 <20100819232655.4223e61f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100819232655.4223e61f@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 05:26:55PM -0400, Jean Delvare wrote:
> On Thu, 19 Aug 2010 12:04:06 -0700, H. Peter Anvin wrote:
> > On 08/19/2010 12:24 AM, Jean Delvare wrote:
> > > 
> > > Thanks for the fix, but it is already in my tree:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-hwmon/hwmon-coretemp-fix-warning.patch
> > > 
> > > I'll send it to Linus as part as my next batch of hwmon fixes for
> > > 2.6.36.
> > 
> > Hi Jean,
> > 
> > Are you overall hwmon maintainer now?  That job is currently listed as
> > Orphan in the MAINTAINERS file.
> 
> MAINTAINERS is correct. I do not have the time, nor the will, to be the
> single official maintainer of the hwmon subsystem. I would be happy to
> be a co-maintainer, but nobody stepped in to co-maintain with me.
> 
I can step in if needed. I don't want to step on anyone's feet, though,
and I would not want to be the sole maintainer, at least not yet - I just
don't know the code well enough.

Guenter
