Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736Ab1KCPPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:15:36 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36253 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495Ab1KCPPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:15:35 -0400
Message-ID: <1320333244.3681.22.camel@js-netbook>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
From: John Stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>
Date: Thu, 03 Nov 2011 11:14:04 -0400
In-Reply-To: <alpine.LFD.2.02.1111031552340.2829@ionos>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
	 <alpine.LFD.2.02.1111031304210.2829@ionos>
	 <1320325819.2892.1.camel@js-netbook>
	 <alpine.LFD.2.02.1111031425200.2829@ionos>
	 <1320328869.3681.17.camel@js-netbook> <1320329371.3681.20.camel@js-netbook>
	 <alpine.LFD.2.02.1111031549240.2829@ionos>
	 <alpine.LFD.2.02.1111031552340.2829@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11110315-6078-0000-0000-000003F2A22C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 15:52 +0100, Thomas Gleixner wrote:
> On Thu, 3 Nov 2011, Thomas Gleixner wrote:
> > On Thu, 3 Nov 2011, John Stultz wrote:
> > > Oh, and the other bit is that not all clocksources have been converted
> > > over to using clocksource_register_hz/khz, so some may be using very
> > > small shift values, which could more easily hit large % mult adjustment
> > > (due to the resulting coarseness of each integer change) that wouldn't
> > > cause overflows.
> > 
> > Fair enough. I'm queuing it.
> 
> That want's a cc stable as well, right ?

Good point. Yes.

thanks
-john


