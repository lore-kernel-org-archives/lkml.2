Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab1AVUxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:53:09 -0500
Received: from smtp-out11.han.skanova.net ([195.67.226.200]:48533 "EHLO
	smtp-out11.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab1AVUxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:53:08 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 22 Jan 2011 21:52:54 +0100
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110122205254.GA2854@polaris.bitmath.org>
References: <20110122134513.1e1d512a@stein>
 <20110122200002.GA1677@polaris.bitmath.org>
 <20110122204050.GB22252@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110122204050.GB22252@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can take it.

Great, thanks.

> Looks pretty straightforward. Do you think it is ready for upstream,
> or should I wait for verification ?

I was able to reproduce the problem, but a verification would still be
good, just in case - if possible. AFAICT, it will be another week
before rc3, so there seems to be no rush.

Thanks,
Henrik
