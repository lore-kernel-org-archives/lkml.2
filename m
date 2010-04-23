Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab0DWPbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:31:55 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:40257 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752283Ab0DWPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:31:53 -0400
Date: Fri, 23 Apr 2010 11:31:45 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, DRI <dri-devel@lists.freedesktop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.34-rc5: Reported regressions from 2.6.33
Message-ID: <20100423153145.GA6072@elliptictech.com>
Mail-Followup-To: Jerome Glisse <glisse@freedesktop.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	DRI <dri-devel@lists.freedesktop.org>,
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
 <20100421165758.GA23565@elliptictech.com>
 <20100423102338.GA3151@barney.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423102338.GA3151@barney.localdomain>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:23 Fri 23 Apr     , Jerome Glisse wrote:
> On Wed, Apr 21, 2010 at 12:57:58PM -0400, Nick Bowler wrote:
> > OK, if the failure is due to userspace is doing Very Bad Things(tm),
> > catching that seems reasonable.
> > 
> > Nevertheless, even if it happened by luck, the result was (ostensibly)
> > working programs that suddenly break once one "upgrades" to the latest
> > kernel.  If userspace can't be fixed before 2.6.34 is released, perhaps
> > a less cryptic log message would be appropriate?
> 
> I pushed fix into mesa for the depth issue i will look into the other
> one today and likely push kernel fix.

Great, thanks.  I'll try out the depth fix tonight.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
