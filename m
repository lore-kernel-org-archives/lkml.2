Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab1KCNKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:10:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59482 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab1KCNKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:10:45 -0400
Message-ID: <1320325819.2892.1.camel@js-netbook>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>
Date: Thu, 03 Nov 2011 09:10:19 -0400
In-Reply-To: <alpine.LFD.2.02.1111031304210.2829@ionos>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
	 <alpine.LFD.2.02.1111031304210.2829@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11110313-3352-0000-0000-0000008B95D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 13:05 +0100, Thomas Gleixner wrote:
> On Wed, 2 Nov 2011, John Stultz wrote:
> >  
> > +	WARN_ONCE(timekeeper.mult+adj >
> > +			timekeeper.clock->mult + timekeeper.clock->maxadj,
> > +			"Adjusting more then 11%%");
> 
> Shouldn't we rather limit the update instead of just warn and overflow ?

Well, I'm hesitant to commit to that, just yet. So I figured I'd start
with the warning.

thanks
-john


