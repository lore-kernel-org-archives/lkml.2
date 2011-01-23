Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1AWQ44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 11:56:56 -0500
Received: from imr4.ericy.com ([198.24.6.8]:50892 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab1AWQ4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 11:56:41 -0500
Date: Sun, 23 Jan 2011 08:55:51 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Henrik Rydberg <rydberg@euromail.se>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110123165551.GA26435@ericsson.com>
References: <20110122134513.1e1d512a@stein>
 <20110122200002.GA1677@polaris.bitmath.org>
 <20110122204050.GB22252@ericsson.com>
 <20110122205254.GA2854@polaris.bitmath.org>
 <20110123000016.387cde2c@stein>
 <20110123133857.GA2641@polaris.bitmath.org>
 <20110123163035.3d692745@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110123163035.3d692745@stein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 10:30:35AM -0500, Stefan Richter wrote:
> On Jan 23 Henrik Rydberg wrote:
> > On Sun, Jan 23, 2011 at 12:00:16AM +0100, Stefan Richter wrote:
> > > With this patch, there is no lockdep warning anymore.  Thanks.
> > 
> > Thank you Stefan. How about a Tested-by, now that I forgot to add a
> > Reported-by to the patch?
> 
> If it hasn't been committed yet,
> Reported-and-tested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Added and applied.

Thanks,
Guenter
