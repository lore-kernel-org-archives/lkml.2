Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0ENW50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:57:26 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53902 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0ENW5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:57:24 -0400
Date: Fri, 14 May 2010 23:57:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] MMC: OMAP HS-MMC: convert to dev_pm_ops
Message-ID: <20100514225720.GA13046@console-pimps.org>
References: <1273615036-4516-1-git-send-email-khilman@deeprootsystems.com>
 <87k4r74p01.fsf@linux-g6p1.site>
 <87ljbmmnp2.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljbmmnp2.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:51:21AM -0700, Kevin Hilman wrote:
> 
> I don't see a reason either, but it requires patching the MMC core as
> well as all the users.  As I'm not an MMC core person, I thought this
> best left to someone in that domain.
> 
> Fixing the core and callers could easily be done on top of this patch.

I've sent a patch that fixes up all the callers now and Andrew has taken
it into -mm.
