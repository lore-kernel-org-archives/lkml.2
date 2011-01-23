Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1AWPbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:31:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35179 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1AWPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:31:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 23 Jan 2011 16:30:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110123163035.3d692745@stein>
In-Reply-To: <20110123133857.GA2641@polaris.bitmath.org>
References: <20110122134513.1e1d512a@stein>
	<20110122200002.GA1677@polaris.bitmath.org>
	<20110122204050.GB22252@ericsson.com>
	<20110122205254.GA2854@polaris.bitmath.org>
	<20110123000016.387cde2c@stein>
	<20110123133857.GA2641@polaris.bitmath.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 23 Henrik Rydberg wrote:
> On Sun, Jan 23, 2011 at 12:00:16AM +0100, Stefan Richter wrote:
> > With this patch, there is no lockdep warning anymore.  Thanks.
> 
> Thank you Stefan. How about a Tested-by, now that I forgot to add a
> Reported-by to the patch?

If it hasn't been committed yet,
Reported-and-tested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
-- 
Stefan Richter
-=====-==-== ---= =-===
http://arcgraph.de/sr/
