Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab1BXWbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:31:00 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:60616 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399Ab1BXWa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:30:59 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 24 Feb 2011 23:31:59 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: bcm5974 - Report button also for zero fingers
Message-ID: <20110224223159.GA6173@polaris.bitmath.org>
References: <1298576264-1563-1-git-send-email-rydberg@euromail.se>
 <20110224222058.GA2448@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224222058.GA2448@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PsjhN-0000cR-9w.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PsjhN-0000cR-9w 68fd0f64d46a4fbded933feb6c1a8b84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 02:20:59PM -0800, Dmitry Torokhov wrote:
> On Thu, Feb 24, 2011 at 08:37:44PM +0100, Henrik Rydberg wrote:
> > With the current code, pressing the integrated button with an
> > isolating tool does not result in any button report. Fixed
> > with this this patch.
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi Dmitry,
> > 
> > that nobody every complained about this bug is beyond me...
> 
> I guess nobody uses styluses to work with the touchpad... I'll apply it
> of course, but since I do not recall bug reports I'll hold it till .39 I
> think.

I was hoping it could slip into 2.6.38 - I can even produce a bug
report if needed. :-)

Henrik
