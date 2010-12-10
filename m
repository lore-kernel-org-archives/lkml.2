Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0LJCZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:25:03 -0500
Received: from www.tglx.de ([62.245.132.106]:46648 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab0LJCZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:25:01 -0500
Date: Fri, 10 Dec 2010 03:24:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Ohlstein <johlstei@codeaurora.org>
cc: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        ? <arve@android.com>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: Re: [PATCH v2 4/6] msm: timer: SMP timer support for msm
In-Reply-To: <4D018B78.4010901@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1012100323400.2653@localhost6.localdomain6>
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org> <1291782501-3909-5-git-send-email-johlstei@codeaurora.org> <4D018B78.4010901@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Jeff Ohlstein wrote:
> >  struct sys_timer msm_timer = {
> >  	.init = msm_timer_init
> >  };
> >   
> Thomas, do you have any additional thoughts on this? Did I answer your
> questions
> sufficiently in the other thread?

I think so. I did not realize the PPI issue in the first place.

Thanks,

	tglx
