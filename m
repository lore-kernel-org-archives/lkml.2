Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1BISkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:40:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48031 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755155Ab1BISkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:40:13 -0500
Date: Wed, 9 Feb 2011 18:40:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: frank.rowand@am.sony.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management
 all the time
Message-ID: <20110209184010.GB23747@opensource.wolfsonmicro.com>
References: <4D51D341.3040209@am.sony.com>
 <20110209114137.GA10163@opensource.wolfsonmicro.com>
 <201102091807.03094.rjw@sisk.pl>
 <4D52DD81.7050401@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D52DD81.7050401@am.sony.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:31:29AM -0800, Frank Rowand wrote:

> Raphael's patch will turn on CONFIG_PM in the correct circumstances, and
> leave it off when not needed by other config options.  That means that
> the size overhead will _not_ be an issue for me because CONFIG_PM
> will not be enabled when not needed.

That's not the issue you seemed to be raising, though.  While PM is now
turned on by PM_SLEEP that'll end up getting turned on by default due to
the dependency on SUSPEND - you appeared to be raising the concern that
this could happen and surprise users.
