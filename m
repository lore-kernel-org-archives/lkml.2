Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1AVXAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 18:00:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59152 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1AVXAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 18:00:44 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 23 Jan 2011 00:00:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110123000016.387cde2c@stein>
In-Reply-To: <20110122205254.GA2854@polaris.bitmath.org>
References: <20110122134513.1e1d512a@stein>
	<20110122200002.GA1677@polaris.bitmath.org>
	<20110122204050.GB22252@ericsson.com>
	<20110122205254.GA2854@polaris.bitmath.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22 Henrik Rydberg wrote:
> > I can take it.
> 
> Great, thanks.
> 
> > Looks pretty straightforward. Do you think it is ready for upstream,
> > or should I wait for verification ?
> 
> I was able to reproduce the problem, but a verification would still be
> good, just in case - if possible. AFAICT, it will be another week
> before rc3, so there seems to be no rush.

With this patch, there is no lockdep warning anymore.  Thanks.
-- 
Stefan Richter
-=====-==-== ---= =-==-
http://arcgraph.de/sr/
