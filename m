Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab0GKVRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:17:08 -0400
Received: from imr1.ericy.com ([198.24.6.9]:35196 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab0GKVRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:17:06 -0400
Date: Sun, 11 Jul 2010 14:15:47 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Goyette <paul@whooppee.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add strict test of logical test
 continuations at beginning of line
Message-ID: <20100711211547.GA24666@ericsson.com>
References: <1278859984-22593-1-git-send-email-guenter.roeck@ericsson.com>
 <1278862266.1501.59.camel@Joe-Laptop.home>
 <20100711161658.GA23927@ericsson.com>
 <20100711182138.132815e4@hyperion.delvare>
 <1278874632.1501.68.camel@Joe-Laptop.home>
 <20100711213444.4243014c@hyperion.delvare>
 <1278877979.1501.76.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1278877979.1501.76.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 03:52:59PM -0400, Joe Perches wrote:
> On Sun, 2010-07-11 at 21:34 +0200, Jean Delvare wrote:
> > On Sun, 11 Jul 2010 11:57:12 -0700, Joe Perches wrote:
> > > I don't remember that discussion.  Link?
> > http://lkml.org/lkml/2009/12/5/65
> > You started the thread, so I would think you'd remember it.
> 
> Though there are differences in opinion about what's important,
> I try to forget the trivial.  Just ask my sweet wife...
> 
Same issue hit me twice now, so it isn't as if nobody cares. 

For my part, I don't care where to put the &&. But I would like to have a means 
to get beyond the basic stuff before submitting my patches, to give reviewers 
an opportunity to find the _real_ problems in my code.

Guenter
