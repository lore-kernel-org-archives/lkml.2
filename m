Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1AGSsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:48:38 -0500
Received: from kroah.org ([198.145.64.141]:51211 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab1AGSsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:48:36 -0500
Date: Fri, 7 Jan 2011 10:32:28 -0800
From: Greg KH <greg@kroah.com>
To: pratyush <pratyush.anand@st.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] ST SPEAr: PCIE gadget suppport
Message-ID: <20110107183228.GB14638@kroah.com>
References: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com>
 <20110106184840.GA21672@kroah.com>
 <4D26D55D.4010600@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D26D55D.4010600@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:27:01PM +0530, pratyush wrote:
> On 1/7/2011 12:18 AM, Greg KH wrote:
> > On Thu, Jan 06, 2011 at 05:29:10PM +0530, Viresh Kumar wrote:
> >> From: Pratyush Anand <pratyush.anand@st.com>
> >>
> >> This is a configurable gadget. can be configured by sysfs interface. Any
> >> IP available at PCIE bus can be programmed to be used by host
> >> controller.It supoorts both INTX and MSI.
> >> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
> >> with size 0x1000
> >>
> >> Changes since V1:
> >> - __iomem added for register addresses
> >> - kerneldoc comment removed whereever not required.
> >> - help node moved from sysfs to documentation/misc-devices
> >> - strict_strtoul used instead of sscanf
> >>
> >> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> >> ---
> >>  Documentation/misc-devices/spear-pcie-gadget.txt |  125 ++++
> > 
> > New sysfs entries require updates to the Documentation/ABI/ directory
> > for them.
> > 
> > Please rework the patch to include these entries.
> > 
> 
> Ok..will send [Patch V3] with these modifications.
> But, are these rework needed if I move this interface to configfs
> as you have suggested below.
> Or is there some different directory where documentation for configfs
> node can be mentioned?

Nope, same directory, you are still creating a user/kernel ABI by using
configfs right?  It needs to be documented just as well.

thanks,

greg k-h
