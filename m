Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab1ADTIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:08:47 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49173 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1ADTIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:08:46 -0500
Subject: Re: [PATCH 2/3] ntp: add ADJ_SETOFFSET mode bit
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>
In-Reply-To: <20110104083733.GA4563@riccoc20.at.omicron.at>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
	 <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
	 <AANLkTi=LqkC-tKzbb6y=iL0UvFYcfcHSuX=jVVFCk1uR@mail.gmail.com>
	 <1294087466.2571.89.camel@work-vm>
	 <20110104083733.GA4563@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 11:08:31 -0800
Message-ID: <1294168111.2694.3.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 09:37 +0100, Richard Cochran wrote:
> On Mon, Jan 03, 2011 at 12:44:26PM -0800, John Stultz wrote:
> > On Wed, 2010-12-29 at 05:47 +0900, Kuwahara,T. wrote:
> > > I came up with this simple solution: "Just use ADJ_OFFSET as usual,
> > > but don't forget to disable the kernel PLL."
> > 
> > Again, this seems to be trying to add new functionality into a corner
> > case of a existing mode.
> > 
> > I don't like this because it makes testing and validating that the code
> > is correct for its uses difficult. Especially given that a number of
> > combinations of modes might be set at once. What happens to freq
> > adjustments done at the same time as an ADJ_OFFSET - STA_PLL?
> 
> Where are the mode bits and their combinations documented, anyhow?
> 
> There are lot of papers on NTP, and I have not read them all, but I
> don't recall having seen a precise and succinct decription of the
> ntp_adjtime interface anywhere.

You can find the original ntp_adjtime description here:
Page 22 of:
http://www.eecis.udel.edu/~mills/database/rfc/rfc1589.txt

This pre-dates the nanotime kernel paper, which added MOD_NANO.

thanks
-john



