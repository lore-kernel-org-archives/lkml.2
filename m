Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0L3BR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 20:17:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:48521 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab0L3BR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 20:17:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,247,1291622400"; 
   d="scan'208";a="641602145"
Subject: Re: Linux 2.6.37-rc8
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
In-Reply-To: <201012291308.58676.rjw@sisk.pl>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	 <20101229111840.GA13498@a1.tnic>  <201012291308.58676.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Dec 2010 09:17:23 +0800
Message-ID: <1293671843.1698.12.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 20:08 +0800, Rafael J. Wysocki wrote:
> On Wednesday, December 29, 2010, Borislav Petkov wrote:
> > On Tue, Dec 28, 2010 at 05:18:12PM -0800, Linus Torvalds wrote:
> > > Another week, another -rc. This should be the last for the 37 series,
> > 
> > There's also the issue with oopsing when physically removing the battery
> > from the system. I have a proposed fix but no acks/nacks from ACPI guys
> > yet:
> > 
> > https://patchwork.kernel.org/patch/418751/
> 
> The commit causing this problem has been reverted:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cde44d1740bcb3dcfecbf792a71826431e61686e
> 
> Which means that the problem it attepmted to address is back.
> 
Right.
After discussion with Len, we agreed that the real problem is that we
should not probe/unprobe power_supply class device in
acpi_battery_update.
And we also agreed on reverting that commit for now, and rewriting the
battery driver, sometime in Q1 2011, with the problem fixed.
Sorry that I didn't update this in the mailing list.

thanks,
rui

> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


