Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0DUJFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:05:09 -0400
Received: from nox2.protox.org ([95.130.11.66]:34645 "EHLO protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0DUJFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:05:06 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 05:05:05 EDT
Date: Wed, 21 Apr 2010 10:57:39 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nick Bowler <nbowler@elliptictech.com>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.34-rc5: Reported regressions from 2.6.33
Message-ID: <20100421085739.GA2576@barney.localdomain>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
 <20100420135636.GA10674@elliptictech.com>
 <201004210715.38621.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004210715.38621.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 07:15:38AM +0200, Rafael J. Wysocki wrote:
> On Tuesday 20 April 2010, Nick Bowler wrote:
> > On 05:15 Tue 20 Apr     , Rafael J. Wysocki wrote:
> > > If you know of any other unresolved regressions from 2.6.33, please let us
> > > know either and we'll add them to the list.  Also, please let us know
> > > if any of the entries below are invalid.
> > 
> > Please list these two similar regressions from 2.6.33 in the r600 DRM:
> > 
> >  * r600 CS checker rejects GL_DEPTH_TEST w/o depth buffer:
> >            https://bugs.freedesktop.org/show_bug.cgi?id=27571
> > 
> >  * r600 CS checker rejects narrow FBO renderbuffers:
> >            https://bugs.freedesktop.org/show_bug.cgi?id=27609
> 
> Do you want to me to add them as one entry or as two separate bugs?
> 
> Rafael
> 

First one is userspace bug, i need to look into the second one.
ie we were lucky the hw didn't lockup without depth buffer and
depth test enabled.

Cheers,
Jerome
