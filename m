Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3ADJSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:18:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3ADJS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:18:29 -0500
Date: Fri, 4 Jan 2013 10:18:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/4 v5 RESEND] rtc: add rtc-driver for HID sensors of
 type time
In-Reply-To: <20130103143913.16d4e867.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1301041017540.9143@pobox.suse.cz>
References: <50CC6FE3.6060705@ahsoftware.de> <1355575537-10093-1-git-send-email-holler@ahsoftware.de> <1355575537-10093-3-git-send-email-holler@ahsoftware.de> <20130103143913.16d4e867.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2013, Andrew Morton wrote:

> > This driver makes the time from HID sensors (hubs) which are offering
> > such available like any other RTC does.
> > 
> > It is necessary that all values like year, month etc, are send as
> > 8bit values (1 byte each) and all of them in 1 report. Also the
> > spec HUTRR39b doesn't define the range of the year field, we
> > tread it as 0 - 99 because that's what most RTCs I know about are
> > offering.
> > 
> > Currently the time can only be read. Setting the time must be done
> > through sending a report (or a feature). The spec currently doesn't
> > define how and I'm not sure if I just should define something by myself.
> > 
> 
> Looks OK to me.  It sounds like Jonathan will be merging these patches
> when he's happy with them - please do proceed that way.

Yes, fine by me as well -- that's why I have provided by explicit Acks to 
those.

Jonathan, are you taking those, please?

-- 
Jiri Kosina
SUSE Labs
