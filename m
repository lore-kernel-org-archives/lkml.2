Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0JRSBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:01:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33374 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab0JRSBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:01:36 -0400
Subject: Re: [PATCH 1/6] [RFC] posix clocks: dynamic clock ids.
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101018142748.GA5767@riccoc20.at.omicron.at>
References: <1287189535-24649-1-git-send-email-john.stultz@linaro.org>
	 <1287189535-24649-2-git-send-email-john.stultz@linaro.org>
	 <20101018142748.GA5767@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 11:01:16 -0700
Message-ID: <1287424876.2758.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 16:27 +0200, Richard Cochran wrote:
> On Fri, Oct 15, 2010 at 05:38:50PM -0700, John Stultz wrote:
> > From: Richard Cochran <richardcochran@gmail.com>
> > 
> > This patch augments the POSIX clock code to offer a dynamic clock
> > creation method. Instead of registering a hard coded clock ID, modules
> > may call create_posix_clock(), which returns a new clock ID.
> > 
> > Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> > 
> > This patch still has un-addressed lifetime issues pointed out by
> > Alan Cox. More work is needed here, but for now this provides the
> > functionality needed for the following patches.
> 
> I am working on a fully dynamic clock implementation in the style
> suggested by Alan. Using it would change some details in this RTC
> patch series, but not the general idea.
> 
> Should I post the dynamic clock stuff all by itself for review?

Yea, that'd be great!

thanks!
-john


