Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1BPPVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:21:20 -0500
Received: from imr4.ericy.com ([198.24.6.8]:42292 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab1BPPVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:21:18 -0500
Date: Wed, 16 Feb 2011 07:20:28 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Clemens Ladisch <clemens@ladisch.de>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 3/3] hwmon: (jc42) do not allow writing to
 locked registers
Message-ID: <20110216152028.GA14199@ericsson.com>
References: <4D5BCA87.7010204@ladisch.de>
 <4D5BCAEE.6030502@ladisch.de>
 <20110216145049.GC13872@ericsson.com>
 <4D5BE927.7000306@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D5BE927.7000306@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 10:11:35AM -0500, Clemens Ladisch wrote:
> Guenter Roeck wrote:
> > On Wed, Feb 16, 2011 at 08:02:38AM -0500, Clemens Ladisch wrote:
> > > +		readonly = config & JC42_CFG_TCRIT_LOCK;
> > 
> > You are assigning a non-bool to a bool. I can see that recent C compilers
> > do the right thing, but I am not sure if that is always the case.
> > So I would prefer
> > 		readonly = !!(config & JC42_CFG_TCRIT_LOCK);
> > 
> > Same for the assignments below. I can make that change if you are ok with it.
> 
> I cannot imagine how a compiler could get this wrong even if it tried
> to, but if you think so, go ahead.  :)
> 
I don't know. Maybe I am just paranoid. Using !! is how I usually see it done.
Is it really needed ? No idea. Better safe than sorry...

Applied with above changes.

Thanks,
Guenter

