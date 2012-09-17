Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab2IQWDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:03:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54298 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab2IQWDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:03:48 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 17 Sep 2012 15:03:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Parag Warudkar <parag.lkml@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
Message-ID: <20120917220356.GA9287@roeck-us.net>
References: <alpine.DEB.2.02.1209151918210.2271@ubuntu>
 <alpine.DEB.2.02.1209152323490.2088@ubuntu>
 <20120916043116.GA4477@roeck-us.net>
 <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu>
 <20120916223003.GA2160@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161957490.2808@ubuntu>
 <20120917162705.GA2854@polaris.bitmath.org>
 <20120917163722.GA1925@roeck-us.net>
 <20120917201436.GA320@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917201436.GA320@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:14:36PM +0200, Henrik Rydberg wrote:
> > Any better/other ideas ? Is the problem that we have to increase the wait time,
> > or is something else going on ?
> 
> No, it makes sense now that I got the right number of zeroes. ;-)
> 
> So, to be explicit, this is the patch I would like to go in. It is
> completely safe, back-portable, and a no-brainer. Parag, are you ok
> with being the author on this one?
> 
> Thanks,
> Henrik
> 
> From 868fc42edcb3a338ce0a0334e2dc50b01a7f6844 Mon Sep 17 00:00:00 2001
> From: Parag Warudkar <parag.lkml@gmail.com>
> Date: Mon, 17 Sep 2012 17:49:55 +0200
> Subject: [PATCH] applesmc: Bump max wait
> 
> A heavy-load test on a MacBookPro6,1 is still showing a substantial
> amount of read errors.  Increasing the maximum wait time to 128 ms
> resolves the issue.
> 
> maybe-Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied after s/maybe-//.

Thanks,
Guenter
