Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2HSFNC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 01:13:02 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54792 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2HSFNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 01:13:00 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 18 Aug 2012 22:12:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        James.Bottomley@HansenPartnership.com, Andi Kleen <ak@linux.intel.com>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH 14/31] sections: Fix section conflicts in drivers/hwmon
Message-ID: <20120819051255.GA11120@roeck-us.net>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
 <1345311022-26328-15-git-send-email-andi@firstfloor.org>
 <20120818232304.GA19997@roeck-us.net>
 <20120819015911.GN11413@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120819015911.GN11413@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 03:59:11AM +0200, Andi Kleen wrote:
> On Sat, Aug 18, 2012 at 04:23:04PM -0700, Guenter Roeck wrote:
> > On Sat, Aug 18, 2012 at 10:30:05AM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > Applied.
> > 
> 
> Thanks.
> 
> > Looks like you did not include maintainers and/or subject mailing lists in your
> > patch series, so I guess you won't get much feedback.
> 
> Tree sweeps like this normally don't go through individual mainainers, it's just
> not practical.
> 
That is not the point. For my part I still like to know what is going on, at
the very least to be able to avoid conflicts, and some maintainers tend to get
a bit tense if they are not informed. Besides, I would consider it to be a
common courtesy to inform maintainers about activity related to their area of
responsibility.

If you want the patch to go through some other tree, fine with me; I can drop it
and give it an Ack. Your e-mail does not mention a target tree, though, and my
psychic capabilities seem to be a bit erratic lately ;).

Guenter
