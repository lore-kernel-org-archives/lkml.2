Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab1JGGxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 02:53:37 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57451 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389Ab1JGGxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 02:53:36 -0400
X-Sasl-enc: 42lhZ+7WrNvZiDKkT7PuPMSlfLDhWJoOvq994yKG1PPp 1317970415
Date: Thu, 6 Oct 2011 23:52:37 -0700
From: Greg KH <greg@kroah.com>
To: Himanshu Chauhan <hschauhan@nulltrace.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
Message-ID: <20111007065237.GA27805@kroah.com>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <20111005193359.GB26664@kroah.com>
 <20111006041011.GB2125@ubuntu.ubuntu-domain>
 <20111006182500.GA18607@kroah.com>
 <20111006190752.GA28455@ericsson.com>
 <20111007064240.GA2944@ubuntu.ubuntu-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007064240.GA2944@ubuntu.ubuntu-domain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 12:12:40PM +0530, Himanshu Chauhan wrote:
> On Thu, Oct 06, 2011 at 12:07:52PM -0700, Guenter Roeck wrote:
> > And why, and what for.
> 
> The initial idea of posting to kernelnewbies was to get a hint on how
> the patch would be taken as. I wanted to know if developers will like
> the idea behind it or not. I guess, Guenter is not convinced with
> any of my reasoning. I am willing to clean it up further only if
> I get a positive hint. But it doesn't seem to be going anywhere.
> 
> Thanks Guenter, Alan, and Greg for taking your time and reviewing it.
> 
> Greg: To answer your last question, if this was taken positively, I
> was thinking of having functionality similar to misc device registration.

But why?  What is that device node going to be used for?  Who would be
using it in userspace and where would it be tied into in the kernel?

still confused,

greg k-h
