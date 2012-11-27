Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2K0WYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:24:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2K0WX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:23:59 -0500
Date: Tue, 27 Nov 2012 14:23:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <p_gortmaker@yahoo.com>, <dchen@diasemi.com>,
        <rtc-linux@googlegroups.com>, Alessandro Zummo <a.zummo@towertech.it>,
        shubhro <omaplinuxkernel@gmail.com>
Subject: Re: [Patch v3 3/7] rtc: DA9055 RTC driver
Message-Id: <20121127142358.9a4bc20d.akpm@linux-foundation.org>
In-Reply-To: <1353665463.1760.3000.camel@dhruva>
References: <1349952025.9228.3.camel@dhruva>
	<1350986593.23353.3.camel@dhruva>
	<1353665463.1760.3000.camel@dhruva>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012 15:41:03 +0530
Ashish Jangam <ashish.jangam@kpitcummins.com> wrote:

> On Tue, 2012-10-23 at 15:33 +0530, Ashish Jangam wrote:
> > Does this patch looks good?
> > On Thu, 2012-10-11 at 16:10 +0530, Ashish Jangam wrote:
> > > This is the RTC patch for the DA9055 PMIC. This patch has got dependency on
> > > the DA9055 MFD core.
> > > 
> > > This patch is functionally tested on Samsung SMDKV6410.
> > > 
> >

(Top-posting repaired. Please don't top-post).

> Any comments on this patch.

"shubhro <omaplinuxkernel@gmail.com>" made a comment, but it was ignored:

: On Thu, 11 Oct 2012 16:53:34 +0530
: shubhro <omaplinuxkernel@gmail.com> wrote:
: 
: > On Thursday 11 October 2012 04:10 PM, Ashish Jangam wrote:
: > > +#define da9055_rtc_freeze NULL
: > > +#endif
: > > +
: > > +static const struct dev_pm_ops da9055_rtc_pm_ops = {
: > > +	.suspend = da9055_rtc_suspend,
: > > +	.resume = da9055_rtc_resume,
: > > +
: > > +	.freeze = da9055_rtc_freeze,
: > > +	.thaw = da9055_rtc_resume,
: > > +	.restore = da9055_rtc_resume,
: > > +
: > > +	.poweroff = da9055_rtc_suspend,
: > > +};
: > You may want to use simple dev pm ops


