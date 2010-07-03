Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0GCPMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 11:12:47 -0400
Received: from imr1.ericy.com ([198.24.6.9]:33559 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab0GCPMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 11:12:46 -0400
Date: Sat, 3 Jul 2010 08:11:56 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lars4910@hotmail.com" <lars4910@hotmail.com>,
       "birdie@permonline.ru" <birdie@permonline.ru>,
       "jadcock@cox.net" <jadcock@cox.net>,
       "binximeng@gmail.com" <binximeng@gmail.com>
Subject: Re: [PATCH/RFC v2] hwmon: Add support for W83667HG-B and
 W83667HG-I to w83627ehf driver.
Message-ID: <20100703151156.GA18122@ericsson.com>
References: <1278062606-29000-1-git-send-email-guenter.roeck@ericsson.com>
 <20100703103536.2fdd833e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100703103536.2fdd833e@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 04:35:36AM -0400, Jean Delvare wrote:
[...]
> 
> Other than this, I have no objection, your patch looks sane.
> 
> After your next iteration, I'll publish a standalone driver with your
> patch, for easier testing.
> 
I submitted v3 a minute ago. I had to make a couple of additional changes,
so you'll have to at least browse through it again. This is still a single 
patch. There are some generic changes, though, so I plan to split it into 
a generic patch and a -B specific patch next time around. Would be great
to get some test feedback first, though.

Guenter
