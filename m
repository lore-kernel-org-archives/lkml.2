Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1KCOxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:53:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:58815 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab1KCOxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:53:01 -0400
Date: Thu, 3 Nov 2011 15:52:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <johnstul@us.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
In-Reply-To: <alpine.LFD.2.02.1111031549240.2829@ionos>
Message-ID: <alpine.LFD.2.02.1111031552340.2829@ionos>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>  <alpine.LFD.2.02.1111031304210.2829@ionos>  <1320325819.2892.1.camel@js-netbook>  <alpine.LFD.2.02.1111031425200.2829@ionos>  <1320328869.3681.17.camel@js-netbook> <1320329371.3681.20.camel@js-netbook>
 <alpine.LFD.2.02.1111031549240.2829@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011, Thomas Gleixner wrote:
> On Thu, 3 Nov 2011, John Stultz wrote:
> > Oh, and the other bit is that not all clocksources have been converted
> > over to using clocksource_register_hz/khz, so some may be using very
> > small shift values, which could more easily hit large % mult adjustment
> > (due to the resulting coarseness of each integer change) that wouldn't
> > cause overflows.
> 
> Fair enough. I'm queuing it.

That want's a cc stable as well, right ?

 
