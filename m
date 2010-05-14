Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0EODnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 23:43:45 -0400
Received: from kroah.org ([198.145.64.141]:47337 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0EODnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 23:43:43 -0400
Date: Thu, 13 May 2010 20:03:44 -0700
From: Greg KH <greg@kroah.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
Message-ID: <20100514030344.GA32571@kroah.com>
References: <4BEC4B0D.8010102@example.com> <4BEC4CD6.6090402@example.com> <4BEC52C0.1000403@xenotime.net> <4BECACC3.3020309@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BECACC3.3020309@example.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 03:52:03AM +0200, Piotr Hosowicz wrote:
> Thanks, I have it disabled. I asked tyhe question because of such messages 
> during boot:
>
> May 13 16:26:24 aapi205 udevd[1432]: SYSFS{}= will be removed in a future 
> udev version, please use ATTR{}= to match the event device, or ATTRS{}= to 
> match a parent device, in /etc/udev/rules.d/025_logitechmouse.rules:21
>
> As far as I can see this is rather udev question. I don't know what to do 
> about those messages. Can you give me a hint?

The above message tells you exactly what you need to fix in the udev
rule.  Please file a bug against the package that the rule came from,
this is not a kernel or even a udev issue, but rather a packaging issue.

good luck,

greg k-h
