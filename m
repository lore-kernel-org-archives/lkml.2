Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab1DMWak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:30:40 -0400
Received: from mail.perches.com ([173.55.12.10]:4691 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313Ab1DMWai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:30:38 -0400
Subject: Re: Re-send (What else needs to be done to the sep driver
 (staging/sep))
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: "Mark A. Allyn" <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, jayant.mangalampalli@intel.com,
        venkat.r.gokulrangan@intel.com
In-Reply-To: <20110413222332.GA32013@kroah.com>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
	 <1302731811.11415.38.camel@Joe-Laptop>  <20110413222332.GA32013@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 15:30:36 -0700
Message-ID: <1302733836.11415.42.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 15:23 -0700, Greg KH wrote:
> Ick, no, never use your own macros, just use the "real" things like is
> done in this driver.  If it's a pain to get to that pointer, then use a
> temporary variable in the code and then use it.
> 
> Otherwise, no, I don't like this patch at all, sorry.

I think you're simply incorrect here.

There are lots of other uses like netdev_<foo>
where <foo>_<level> takes a particular pointer type.

This is a structure that contains a pointer to
another structure than contains a struct device.

You might also look at the macros the USB subsystem
uses for message logging.

Hey, aren't you the USB maintainer?

