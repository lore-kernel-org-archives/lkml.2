Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1JQJZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:25:07 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:59094 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1JQJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:25:05 -0400
X-IronPort-AV: E=Sophos;i="4.69,358,1315180800"; 
   d="scan'208";a="8417741"
Subject: Re: [Xen-devel] Re: xen: IPI interrupts not resumed early enough on
 suspend/resume
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 17 Oct 2011 10:25:03 +0100
In-Reply-To: <alpine.LFD.2.02.1110171049440.3240@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110032033530.1489@ionos>
	 <1317668908.11991.20.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.02.1110032229250.1489@ionos>
	 <1318001583.21903.355.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110071822160.3240@ionos>
	 <1318251990.21903.433.camel@zakaz.uk.xensource.com>
	 <1318598637.21903.889.camel@zakaz.uk.xensource.com>
	 <1318713254.11016.52.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.02.1110171049440.3240@ionos>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318843504.16132.1.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 09:51 +0100, Thomas Gleixner wrote:
> On Sat, 15 Oct 2011, Ian Campbell wrote:
> 
> > On Fri, 2011-10-14 at 14:23 +0100, Ian Campbell wrote:
> > > Ping? The original issue has made it into longterm-2.6.32.y and then
> > > onto Debian (bug #644604) so people keep asking me about it...
> > 
> > Sorry, the previous version had a warning in it (was missing the return
> > type for resume_irqs), fixed up version follows.
> > 
> > I noticed that the backport to longterm 2.6.32 won't work since syscore
> > isn't available back then. I think one approach for the backport would
> > be to call irq_pm_syscore_resume() directly from sysdev_resume(), does
> > that sound sensible?
> 
> I think so. Can you please add a description (or the five lines patch)
> for the stable folks to the changelog, so they don't have to dig
> around ?

If you are happy with the mainline version I'll send out a backported
version to stable@.

Ian.


