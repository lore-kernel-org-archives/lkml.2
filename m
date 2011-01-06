Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab1AFKCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:02:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:43835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1AFKCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:02:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,282,1291622400"; 
   d="scan'208";a="874970707"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
Date: Thu, 6 Jan 2011 18:05:27 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <201101061723.29523.sheng@linux.intel.com> <1294306557.3831.3610.camel@zakaz.uk.xensource.com>
In-Reply-To: <1294306557.3831.3610.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061805.27674.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 January 2011 17:35:57 Ian Campbell wrote:
> On Thu, 2011-01-06 at 17:23 +0800, Sheng Yang wrote:
> > Thanks for the comments, but seems it's a little late. The patches have
> > been there for more than a month since the first version, and now they
> > are finally in the tree... And since it's not a bug, could we leave it
> > to the later clean up?
> 
> Sure. Are you going to do that?

OK, I would do it later.

--
regards
Yang, Sheng

> 
> > > > > Also, checking for the XenVMMXenVMM signature alone seems like a
> > > > > very broad test for checking the availability of a specific
> > > > > feature, is there nothing more specific which we could/should be
> > > > > testing?
> > > > 
> > > > The CPU flag x2apic is checked when we want to enable x2apic, and
> > > > only Xen which supported x2apic emulation would show this flag.
> > > 
> > > A comment to that effect, in the checkin commentary if not the code,
> > > would be a useful reminder of this.
> > 
> > The caller of the function indicate so, it's in the x2apic enabling
> > code(which is the same as KVM). So I think that maybe enough.
> 
> It's not obvious to the likes of me but if it makes sense to people who
> know x2apic (but not necessarily Xen or KVM) then I guess it's ok.
> 
> Ian.
