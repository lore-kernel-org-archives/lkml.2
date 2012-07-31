Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2GaDMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 23:12:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:23704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab2GaDMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 23:12:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="200238198"
Message-ID: <1343704341.2591.8.camel@yhuang-dev>
Subject: Re: [RFC] PCI/PM: Add ABI document for sysfs file d3cold_allowed
From: Huang Ying <ying.huang@intel.com>
To: Don Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Mork <bjorn@mork.no>
Date: Tue, 31 Jul 2012 11:12:21 +0800
In-Reply-To: <5016CC75.3050806@redhat.com>
References: <1343376454-28520-1-git-send-email-ying.huang@intel.com>
	 <5016CC75.3050806@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don,

Thanks for your comments.

On Mon, 2012-07-30 at 14:03 -0400, Don Dutile wrote:
> On 07/27/2012 04:07 AM, Huang Ying wrote:
> > This patch adds ABI document for the following sysfs file:
> >
> > /sys/bus/pci/devices/.../d3cold_allowed
> >
> > Signed-off-by: Huang Ying<ying.huang@intel.com>
> > ---
> >   Documentation/ABI/testing/sysfs-bus-pci |   12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> >
> > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > @@ -210,3 +210,15 @@ Users:
> >   		firmware assigned instance number of the PCI
> >   		device that can help in understanding the firmware
> >   		intended order of the PCI device.
> > +
> > +What:		/sys/bus/pci/devices/.../d3cold_allowed
> > +Date:		July 2012
> > +Contact:	Huang Ying<ying.huang@intel.com>
> > +Description:
> > +		d3cold_allowed is bit to control whether the corresponding PCI
> > +		device can be put into D3Cold state.  If it is cleared, the
> > +		device will never be put into D3Cold state.  If it is set, the
> > +		device may be put into D3Cold state if other requirement are
> did you mean 'requirements' here? -------------------------------^
> or is there only 1 other requirement?

I mean requirements here.

> 
> > +		satisfied too.  Reading this attribute will show the current
> > +		value of d3cold_allowed bit.  Writting this attribute will set
> spell checker says 'Writing' --------------------^

Sorry about my poor English and I should have spell checked it before
sending out.

Best Regards,
Huang Ying


