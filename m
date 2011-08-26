Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1HZXhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:37:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:5129 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1HZXhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:37:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="42683501"
Subject: Re: MTRR setup failure on Fujitsu Lifebook S761
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Tony Vroon <tony@linx.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, "yinghai@kernel.org" <yinghai@kernel.org>,
        venki@google.com, Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 26 Aug 2011 16:40:33 -0700
In-Reply-To: <1314394765.8356.5.camel@localhost>
References: <4E579397.6010009@linx.net>  <4E57CBBB.3040806@zytor.com>
	 <1314385315.8356.0.camel@localhost>
	 <1314394157.4729.23.camel@sbsiddha-desk.sc.intel.com>
	 <1314394765.8356.5.camel@localhost>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314402034.4729.33.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 14:39 -0700, Tony Vroon wrote:
> On Fri, 2011-08-26 at 14:29 -0700, Suresh Siddha wrote:
> > And you seem to say, things were _little_ bit better by using a MTRR
> > script. What do you mean by _little_ ?
> 
> Little in that scrolling in terminals seems to work better. A failure
> mode where the mouse cursor refuses to move seems to occur less often.

Ok. With out your MTRR script and with kernel boot parameter "nopat"
does the perf issue you have seen remain same or becomes further worse?

Perhaps some of the driver mappings are not setting the PAT attribute
correctly or the PAT attribute doesn't help at all. The above experiment
will give us some clue.

> > Do you still see the original issue of hangcheck timer elapsed and it
> > is just that the MTRR warning from drm driver disappeared with your
> > MTRR script?
> 
> Yes, the hangcheck timer checks still fire intermittently and graphics
> performance is still hit & miss. There is a failure mode that I call the
> Amiga loading screen where vertical lines appear that are all a pixel
> wide and are continuously changing in colour.

This one seems to be a different issue that need to be reported to the
graphics folks.

thanks.

> 
> The AGP aperture is exactly 256MB in the location that the DRM warning
> complained about, so what I did with the script was an attempt to answer
> its lament. It accept that it may be completely meaningless in practice.
> 
> Regards,
> Tony V.


