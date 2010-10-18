Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0JRUpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:45:00 -0400
Received: from www.tglx.de ([62.245.132.106]:33236 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0JRUo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:44:59 -0400
Date: Mon, 18 Oct 2010 22:44:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 1/6] [RFC] posix clocks: dynamic clock ids.
In-Reply-To: <20101018142748.GA5767@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1010182243580.6815@localhost6.localdomain6>
References: <1287189535-24649-1-git-send-email-john.stultz@linaro.org> <1287189535-24649-2-git-send-email-john.stultz@linaro.org> <20101018142748.GA5767@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Richard Cochran wrote:

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

Incremental is preferred. We all know by now what it's going to be
used for.
 
Thanks,

	tglx
