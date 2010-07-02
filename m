Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab0GBJv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:51:27 -0400
Received: from poutre.nerim.net ([62.4.16.124]:61381 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab0GBJvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:51:25 -0400
Date: Fri, 2 Jul 2010 11:51:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lars4910@hotmail.com" <lars4910@hotmail.com>,
       "birdie@permonline.ru" <birdie@permonline.ru>,
       "jadcock@cox.net" <jadcock@cox.net>
Subject: Re: [PATCH/RFC] hwmon: Add support for W83667HG-B
Message-ID: <20100702115123.18e95e14@hyperion.delvare>
In-Reply-To: <20100702083144.GD12911@ericsson.com>
References: <1278021735-21188-1-git-send-email-guenter.roeck@ericsson.com>
	<20100702092011.0acd753f@hyperion.delvare>
	<20100702080704.GA12911@ericsson.com>
	<20100702101345.6fe9d27a@hyperion.delvare>
	<20100702083144.GD12911@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010 01:31:44 -0700, Guenter Roeck wrote:
> On Fri, Jul 02, 2010 at 04:13:45AM -0400, Jean Delvare wrote:
> > On Fri, 2 Jul 2010 01:07:04 -0700, Guenter Roeck wrote:
> > > I'll also add a check for the HG-I.
> > 
> > Do you have a datasheet for that one too?
> > 
> No. However, since we have a tester, we will have test coverage,
> so I figured it should be worth a try. If it doesn't work
> I can still drop it from the final patch.

FYI, I have a datasheet, which unfortunately I am not allowed to share.
Please let me know if you want me to look up something for you.

> I suspect it is the same as the HG with a different chip ID.

Beware, it's a different device number (677 vs. 667) so I would expect
more differences.

-- 
Jean Delvare
