Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab0JXPgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:36:38 -0400
Received: from imr4.ericy.com ([198.24.6.8]:59263 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843Ab0JXPgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:36:37 -0400
Date: Sun, 24 Oct 2010 08:35:48 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
CC: Samu Onkalo <samu.p.onkalo@nokia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] lis3 accelerator feature update
Message-ID: <20101024153548.GA14303@ericsson.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
 <4CC44B3D.5030404@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CC44B3D.5030404@tremplin-utc.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 11:05:33AM -0400, Éric Piel wrote:
> Op 22-10-10 13:57, Samu Onkalo schreef:
> > Changes are tested only with I2C interface using 8bit sensor since I don't
> > have other possibilities. Some features are not enabled
> > by default since I can't test them with all possible configurations.
> > Platform data contains field which controls new features.
> Thanks Samu for persevering with the automatic power down feature. 
> Hopefully I'll find also some time to activate it on the hp_accel side.
> 
> For now, I've reviewed the changes and everything looked fine, as well 
> as tested them on my HP laptop (with a 12 bits sensor). Although most of 
> the changes are not visible on this platform, at least there shouldn't 
> be any regression.
> 
Great, thanks.

Unfortunately, the patches don't apply to my staging branch, probably
because of the other pending lis3 changes.

Samu, please rebase your patches to 
	git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-next
and resubmit.

Thanks,
Guenter
