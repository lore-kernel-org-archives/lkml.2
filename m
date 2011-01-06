Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1AFJgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:36:13 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:7970 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab1AFJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:36:10 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201101061723.29523.sheng@linux.intel.com>
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com>
	 <201101060920.47797.sheng@linux.intel.com>
	 <1294305030.3831.3590.camel@zakaz.uk.xensource.com>
	 <201101061723.29523.sheng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 09:35:57 +0000
Message-ID: <1294306557.3831.3610.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=z0RUBZs6AVsA:10 a=IkcTkHD0fZMA:10 a=tO-QY-n3alikPgZONTsA:9 a=oWvAxrM7PvduAgpftvjmhdOejZMA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 17:23 +0800, Sheng Yang wrote:

> Thanks for the comments, but seems it's a little late. The patches have been there 
> for more than a month since the first version, and now they are finally in the 
> tree... And since it's not a bug, could we leave it to the later clean up?

Sure. Are you going to do that?
 
> > > > Also, checking for the XenVMMXenVMM signature alone seems like a very
> > > > broad test for checking the availability of a specific feature, is
> > > > there nothing more specific which we could/should be testing?
> > > 
> > > The CPU flag x2apic is checked when we want to enable x2apic, and only
> > > Xen which supported x2apic emulation would show this flag.
> > 
> > A comment to that effect, in the checkin commentary if not the code,
> > would be a useful reminder of this.
> 
> The caller of the function indicate so, it's in the x2apic enabling code(which is 
> the same as KVM). So I think that maybe enough.

It's not obvious to the likes of me but if it makes sense to people who
know x2apic (but not necessarily Xen or KVM) then I guess it's ok.

Ian.


-- 
Ian Campbell
Current Noise: Death - Spirit Crusher

I know you're in search of yourself, I just haven't seen you anywhere.

