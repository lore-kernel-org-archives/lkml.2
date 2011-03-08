Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1CHLRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:17:25 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:19915 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab1CHLRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:17:24 -0500
X-IronPort-AV: E=Sophos;i="4.62,283,1297036800"; 
   d="scan'208";a="4668374"
Date: Tue, 8 Mar 2011 11:17:04 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: topperxin <topperxin@126.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re:Re:[Xen-devel] [PATCH v2 0/6] Xen PV on HVM fixes and
 improvements
In-Reply-To: <7ef859a1.d96b.12e933f972a.Coremail.topperxin@126.com>
Message-ID: <alpine.DEB.2.00.1103081115250.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103031502090.2968@kaball-desktop> <alpine.DEB.2.00.1102251651570.19277@kaball-desktop> <50e6b629.254d.12e798c9072.Coremail.topperxin@126.com> <7ef859a1.d96b.12e933f972a.Coremail.topperxin@126.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1967298003-1299583024=:2968"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-1967298003-1299583024=:2968
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT

On Tue, 8 Mar 2011, topperxin wrote:
> At 2011-03-03 23:05:09，"Stefano Stabellini" <stefano.stabellini@eu.citrix.com> wrote:
> 
> >On Thu, 3 Mar 2011, topperxin wrote:
> >> Hi stefano,
> >> 
> >>    It's very great of your work.I think it't useful 
> >> to me, I have checked it out, and I will study it.
> >>   What I care mostly is the pv-on-hvm drivers, now 
> >> my main work is port pvonhvm drivers to various guest
> >> OS, no matter what OS version, such as ubuntu 10.10, 
> >> debian 505 etc. But I found this work is difficult & 
> >> boring to me, I can't find a general method which can 
> >> easily port the pvonhvm drivers to all kinds guest os.
> >> Do you have any good ideas?
> >
> >PV on HVM is upstream now, so it is just a matter of time before all the
> >distros will have a kernel that supports PV on HVM out of the box.
> >
> >
> >>    I found there are not platform-pci source in your 
> >> project, as we know, in the old pvonhvm drivers version,
> >> platform-pci module is important, it was used to establish
> >> the communication mechanism, such as xenbus, evtchn,etc, 
> >> could you please tell me how can you get rid of it? and how 
> >> can you substitute platform-pci, with which?
> >
> >Yes there is:
> >drivers/xen/platform-pci.c
> 
> 1.sorry, I can't find platform-pci.c in your release source.
> 2.6.38-rc5-pvhvm
> 2.another question is when I make; make install under 2.6.38-rc5-pvhvm
> I found the version number change from 2.6.38 to 2.6.34 under 
> /lib/modules/2.6.34-rc1
> why?

you must be working on the wrong tree :)

--8323329-1967298003-1299583024=:2968--
