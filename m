Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2HSB7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 21:59:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57962 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2HSB7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 21:59:17 -0400
Date: Sun, 19 Aug 2012 03:59:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 14/31] sections: Fix section conflicts in drivers/hwmon
Message-ID: <20120819015911.GN11413@one.firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org> <1345311022-26328-15-git-send-email-andi@firstfloor.org> <20120818232304.GA19997@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120818232304.GA19997@roeck-us.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 04:23:04PM -0700, Guenter Roeck wrote:
> On Sat, Aug 18, 2012 at 10:30:05AM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Applied.
> 

Thanks.

> Looks like you did not include maintainers and/or subject mailing lists in your
> patch series, so I guess you won't get much feedback.

Tree sweeps like this normally don't go through individual mainainers, it's just
not practical.

-Andi
