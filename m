Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883Ab0GPJp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:45:59 -0400
Received: from tortuga.cyrius.com ([84.45.67.90]:54304 "EHLO
	tortuga.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964864Ab0GPJp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:45:58 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jul 2010 05:45:58 EDT
Date: Fri, 16 Jul 2010 10:37:44 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Lee Jones <lee.jones@canonical.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded -
 2.6.35-rc5
Message-ID: <20100716093744.GN11238@jirafa.cyrius.com>
References: <4C3C72C6.4000005@canonical.com>
 <20100715130214.4c9303b2.akpm@linux-foundation.org>
 <20100715200618.GA6773@n2100.arm.linux.org.uk>
 <4C40218A.4090806@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C40218A.4090806@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lee Jones <lee.jones@canonical.com> [2010-07-16 10:08]:
> >> That sounds like a pretty serious problem.  But presumably it isn't -
> >> otherwise it would have been fixed earlier!
> 
> Well it is a problem on OMAP based boards.

It's not just OMAP.  Debian received a similar bug report a few days
too and it was on Marvell Orion hardware.  I simply disabled the
parport_pc module on ARM.

-- 
Martin Michlmayr
http://www.cyrius.com/
