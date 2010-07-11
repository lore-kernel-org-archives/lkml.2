Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0GKTxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 15:53:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1697 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0GKTxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 15:53:03 -0400
Subject: Re: [PATCH] scripts/checkpatch.pl: Add strict test of logical test
 continuations at beginning of line
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
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
In-Reply-To: <20100711213444.4243014c@hyperion.delvare>
References: <1278859984-22593-1-git-send-email-guenter.roeck@ericsson.com>
	 <1278862266.1501.59.camel@Joe-Laptop.home>
	 <20100711161658.GA23927@ericsson.com>
	 <20100711182138.132815e4@hyperion.delvare>
	 <1278874632.1501.68.camel@Joe-Laptop.home>
	 <20100711213444.4243014c@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 12:52:59 -0700
Message-ID: <1278877979.1501.76.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 21:34 +0200, Jean Delvare wrote:
> On Sun, 11 Jul 2010 11:57:12 -0700, Joe Perches wrote:
> > I don't remember that discussion.  Link?
> http://lkml.org/lkml/2009/12/5/65
> You started the thread, so I would think you'd remember it.

Though there are differences in opinion about what's important,
I try to forget the trivial.  Just ask my sweet wife...

