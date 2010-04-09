Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab0DIBOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 21:14:49 -0400
Received: from smtp.knology.net ([24.214.63.101]:41169 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab0DIBOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 21:14:47 -0400
Subject: Re: [Bug #15454] r8169 exits with error -22 since 2.6.33
From: David Dillow <dave@thedillows.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Conrad Kostecki <ConiKost@gmx.de>, romieu@fr.zoreil.com
In-Reply-To: <onZ81XwyNTD.A.PlC.tEmvLB@chimera>
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
	 <onZ81XwyNTD.A.PlC.tEmvLB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 21:14:43 -0400
Message-ID: <1270775683.26861.4.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 01:04 +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15454
> Subject		: r8169 exits with error -22 since 2.6.33
> Submitter	: Conrad Kostecki <ConiKost@gmx.de>
> Date		: 2010-03-05 22:32 (35 days old)

Francois attached a patch to the bugzilla entry that ignores the failure
to enable MWI on the device. That may get the NIC up and running, but
that area of the driver doesn't seem to have changed since 2.6.32, so
perhaps this is just a canary -- I'm betting that the cache line size is
not getting set properly, and it probably affects more than just this
NIC.

