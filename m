Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab1JGJ4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:56:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47258 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759685Ab1JGJ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:56:30 -0400
Date: Fri, 7 Oct 2011 15:26:21 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Greg KH <greg@kroah.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
Message-ID: <20111007095621.GB2944@ubuntu.ubuntu-domain>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <20111005193359.GB26664@kroah.com>
 <20111006041011.GB2125@ubuntu.ubuntu-domain>
 <20111006182500.GA18607@kroah.com>
 <20111006190752.GA28455@ericsson.com>
 <20111007064240.GA2944@ubuntu.ubuntu-domain>
 <20111007065237.GA27805@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007065237.GA27805@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 11:52:37PM -0700, Greg KH wrote:
> On Fri, Oct 07, 2011 at 12:12:40PM +0530, Himanshu Chauhan wrote:
> > On Thu, Oct 06, 2011 at 12:07:52PM -0700, Guenter Roeck wrote:
> > > And why, and what for.
> > 
> > The initial idea of posting to kernelnewbies was to get a hint on how
> > the patch would be taken as. I wanted to know if developers will like
> > the idea behind it or not. I guess, Guenter is not convinced with
> > any of my reasoning. I am willing to clean it up further only if
> > I get a positive hint. But it doesn't seem to be going anywhere.
> > 
> > Thanks Guenter, Alan, and Greg for taking your time and reviewing it.
> > 
> > Greg: To answer your last question, if this was taken positively, I
> > was thinking of having functionality similar to misc device registration.
> 
> But why?  What is that device node going to be used for?  Who would be
> using it in userspace and where would it be tied into in the kernel?
> 
The device node, as I said earlier, can be used for doing IOCTLS. In user space,
applications that manage and monitor system environment will need to use this
interface for querying the sensor's location, for example. In side the kernel,
the driver that is driving the particular hardware sensor can register a char
interface for all this and then register with hwmon with the same major/minor
for usual sysfs export of data.

-Himanshu
