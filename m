Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0DUQ6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:58:23 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:57544 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751976Ab0DUQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:58:20 -0400
Date: Wed, 21 Apr 2010 12:57:58 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, DRI <dri-devel@lists.sourceforge.net>,
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
Message-ID: <20100421165758.GA23565@elliptictech.com>
Mail-Followup-To: Jerome Glisse <glisse@freedesktop.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
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
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
 <20100420135636.GA10674@elliptictech.com>
 <201004210715.38621.rjw@sisk.pl>
 <20100421085739.GA2576@barney.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421085739.GA2576@barney.localdomain>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 07:15:38AM +0200, Rafael J. Wysocki wrote:
> On Tuesday 20 April 2010, Nick Bowler wrote:
> > Please list these two similar regressions from 2.6.33 in the r600 DRM:
> > 
> >  * r600 CS checker rejects GL_DEPTH_TEST w/o depth buffer:
> >            https://bugs.freedesktop.org/show_bug.cgi?id=27571
> > 
> >  * r600 CS checker rejects narrow FBO renderbuffers:
> >            https://bugs.freedesktop.org/show_bug.cgi?id=27609
> 
> Do you want to me to add them as one entry or as two separate bugs?

As upstream doesn't consider the first to be a kernel issue, I guess you
should just list the second.

On 10:57 Wed 21 Apr     , Jerome Glisse wrote:
> First one is userspace bug, i need to look into the second one.
> ie we were lucky the hw didn't lockup without depth buffer and
> depth test enabled.

OK, if the failure is due to userspace is doing Very Bad Things(tm),
catching that seems reasonable.

Nevertheless, even if it happened by luck, the result was (ostensibly)
working programs that suddenly break once one "upgrades" to the latest
kernel.  If userspace can't be fixed before 2.6.34 is released, perhaps
a less cryptic log message would be appropriate?

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
