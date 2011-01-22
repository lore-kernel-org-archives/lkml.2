Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1AVUli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:41:38 -0500
Received: from imr4.ericy.com ([198.24.6.8]:43363 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab1AVUlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:41:37 -0500
Date: Sat, 22 Jan 2011 12:40:50 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110122204050.GB22252@ericsson.com>
References: <20110122134513.1e1d512a@stein>
 <20110122200002.GA1677@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110122200002.GA1677@polaris.bitmath.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 03:00:02PM -0500, Henrik Rydberg wrote:
> > BUG: key f4891a1c not in .data!
> [...]
> > Any ideas where this may come from?
> 
> The patch below seems to fix the problem, but a verification would be most
> welcome. Gunther, do you want to take it, or should it route it through
> my tree?
> 
I can take it.

Looks pretty straightforward. Do you think it is ready for upstream,
or should I wait for verification ?

Thanks,
Guenter
