Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2K1JZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:25:54 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:6333
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507Ab2K1JZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:25:52 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I936eI1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631hbe9i1155h)
Subject: Re: [Patch v3 3/7] rtc: DA9055 RTC driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <p_gortmaker@yahoo.com>, <dchen@diasemi.com>,
        <rtc-linux@googlegroups.com>, Alessandro Zummo <a.zummo@towertech.it>,
        shubhro <omaplinuxkernel@gmail.com>
In-Reply-To: <20121127142358.9a4bc20d.akpm@linux-foundation.org>
References: <1349952025.9228.3.camel@dhruva>
	 <1350986593.23353.3.camel@dhruva> <1353665463.1760.3000.camel@dhruva>
	 <20121127142358.9a4bc20d.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Nov 2012 14:54:40 +0530
Message-ID: <1354094680.10949.1.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 14:23 -0800, Andrew Morton wrote:
> On Fri, 23 Nov 2012 15:41:03 +0530
> Ashish Jangam <ashish.jangam@kpitcummins.com> wrote:
> 
> > On Tue, 2012-10-23 at 15:33 +0530, Ashish Jangam wrote:
> > > Does this patch looks good?
> > > On Thu, 2012-10-11 at 16:10 +0530, Ashish Jangam wrote:
> > > > This is the RTC patch for the DA9055 PMIC. This patch has got dependency on
> > > > the DA9055 MFD core.
> > > > 
> > > > This patch is functionally tested on Samsung SMDKV6410.
> > > > 
> > >
> 
> (Top-posting repaired. Please don't top-post).
> 
> > Any comments on this patch.
> 
> "shubhro <omaplinuxkernel@gmail.com>" made a comment, but it was ignored:
> 
> : On Thu, 11 Oct 2012 16:53:34 +0530
> : shubhro <omaplinuxkernel@gmail.com> wrote:
> : 
> : > On Thursday 11 October 2012 04:10 PM, Ashish Jangam wrote:
> : > > +#define da9055_rtc_freeze NULL
> : > > +#endif
> : > > +
> : > > +static const struct dev_pm_ops da9055_rtc_pm_ops = {
> : > > +	.suspend = da9055_rtc_suspend,
> : > > +	.resume = da9055_rtc_resume,
> : > > +
> : > > +	.freeze = da9055_rtc_freeze,
> : > > +	.thaw = da9055_rtc_resume,
> : > > +	.restore = da9055_rtc_resume,
> : > > +
> : > > +	.poweroff = da9055_rtc_suspend,
> : > > +};
> : > You may want to use simple dev pm ops
To support generic PM ops these additional ops were supported.


