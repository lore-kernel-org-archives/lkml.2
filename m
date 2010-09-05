Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0IEI46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 04:56:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40955 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754511Ab0IEI45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 04:56:57 -0400
Date: Sun, 5 Sep 2010 09:56:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Williamson <michael.williamson@criticallink.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk, dtor@mail.ru,
        gregkh@suse.de
Subject: Re: [PATCH v1] tps65023: Allow platforms to specify DCDC_2 and
	DCDC_3 value.
Message-ID: <20100905085656.GE24817@opensource.wolfsonmicro.com>
References: <1283624421-10326-1-git-send-email-michael.williamson@criticallink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283624421-10326-1-git-send-email-michael.williamson@criticallink.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 02:20:21PM -0400, Michael Williamson wrote:

> This patch allows a platform to pass in the actual voltage used
> for these DCDC supplies such that they are reported correctly in
> sysfs.

It's doing this using the constraints rather than through platform data,
which isn't really idiomatic.  It would be better to do this with
platform data like the fixed voltage regulator does.

> Built against 2.6.36-rc3.

It doesn't really matter here but you should always submit patches
against linux-next.
