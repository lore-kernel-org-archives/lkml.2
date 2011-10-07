Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1JGGm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 02:42:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33613 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab1JGGmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 02:42:52 -0400
Date: Fri, 7 Oct 2011 12:12:40 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Greg KH <greg@kroah.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
Message-ID: <20111007064240.GA2944@ubuntu.ubuntu-domain>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <20111005193359.GB26664@kroah.com>
 <20111006041011.GB2125@ubuntu.ubuntu-domain>
 <20111006182500.GA18607@kroah.com>
 <20111006190752.GA28455@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006190752.GA28455@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:07:52PM -0700, Guenter Roeck wrote:
> And why, and what for.

The initial idea of posting to kernelnewbies was to get a hint on how
the patch would be taken as. I wanted to know if developers will like
the idea behind it or not. I guess, Guenter is not convinced with
any of my reasoning. I am willing to clean it up further only if
I get a positive hint. But it doesn't seem to be going anywhere.

Thanks Guenter, Alan, and Greg for taking your time and reviewing it.

Greg: To answer your last question, if this was taken positively, I
was thinking of having functionality similar to misc device registration.

-Himanshu


