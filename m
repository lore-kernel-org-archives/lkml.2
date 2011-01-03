Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab1ACPju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:39:50 -0500
Received: from imr4.ericy.com ([198.24.6.8]:47378 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab1ACPjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:39:49 -0500
Date: Mon, 3 Jan 2011 07:38:49 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: Patch[1/2]X86:Adding_Notification_Support_to_therm_throt.c
Message-ID: <20110103153849.GA25747@ericsson.com>
References: <D6D887BA8C9DFF48B5233887EF04654105C1251710@bgsmsx502.gar.corp.intel.com>
 <20110103150328.GB25600@ericsson.com>
 <D6D887BA8C9DFF48B5233887EF04654105C125176B@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <D6D887BA8C9DFF48B5233887EF04654105C125176B@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 10:11:59AM -0500, R, Durgadoss wrote:
> Hi Guenter,
> 
> > > From: Durgadoss R <durgadoss.r@intel.com>
> > >
> > > Date: Sun, 19 Dec 2010 22:42:45 +0530
> > > Subject: [PATCH 1/2] X86:Adding_core_threshold_notification_to_therm_throt.c
> > >
> > > This patch adds code to therm_throt.c to notify core thermal threshold
> > > events. These thresholds are supported by the IA32_THERM_INTERRUPT register.
> > > The status/log for the same is monitored using the IA32_THERM_STATUS
> > register.
> > > The necessary #defines are in msr-index.h. A call back is added to mce.h, to
> > > further notify the thermal stack, about the threshold events.
> > >
> > > Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> > >
> > If this is just a resubmit, you might instead consider trying to figure out
> > why none of the x86 maintainers replied. Documentation/Submit* might help,
> > as well as comparing your set of patches with other (accepted) patches.
> > 
> 
> This is a resubmission. I thought people might be on holidays..that's why
> resubmitted today. Anyway, I shall try to figure out the reason. Thanks
> for pointing it out Guenter..
> 
> Any comments on the hwmon patch 2/2 ?
> 
Not right now. Futile to spend more time on it unless the x86 changes are accepted.

Guenter
