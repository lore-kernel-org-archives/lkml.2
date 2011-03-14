Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1CNPDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:03:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45320 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab1CNPDj (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 14 Mar 2011 11:03:39 -0400
Date: Mon, 14 Mar 2011 11:03:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] input/xen-fbfront: advertise either absolute or
 relative coordinates
Message-ID: <20110314150321.GB11244@dumpdata.com>
References: <alpine.DEB.2.00.1103111124400.2968@kaball-desktop>
 <20110313062411.GB31566@core.coreip.homeip.net>
 <alpine.DEB.2.00.1103141135170.3382@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103141135170.3382@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D7E2E40.00F4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > BTW, drivers/input is intended for core input and handlers stuff with
> > drivers suppsed to be in drivers/input/<type>. Would you mind if I moved
> > this driver to drivers/input/misc?
> 
> I am OK with it.
> Konrad, any comments on this?

Go for it! Dmitry, were you thinking to do that for 2.6.39 or 2.6.40?

I've two more patches for xen-fbfront (and one for xen-kbdfront) that I was thinking
could go for 2.6.39:

http://lists.colo.xensource.com/archives/html/xen-devel/2011-03/msg00383.html

oh, and they seemed to have not been posted here. I stuck them 
in

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git #devel/fb_kb_front_use_page_gref

and was testing them. Do you want me to repost them on LKML with you
on the CC?

