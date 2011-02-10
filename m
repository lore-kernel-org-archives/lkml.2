Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1BJLbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 06:31:35 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:34141 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188Ab1BJLbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 06:31:34 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Brendan Cully <brendan@cs.ubc.ca>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>
In-Reply-To: <20110209231659.GB249@zanzibar.kublai.com>
References: <Pine.LNX.4.44L0.1102081143470.2100-100000@iolanthe.rowland.org>
	 <1297186554.9388.248.camel@zakaz.uk.xensource.com>
	 <20110209231659.GB249@zanzibar.kublai.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 11:31:13 +0000
Message-ID: <1297337473.20491.144.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: [linux-pm] [PATCH 0/2] Fix hangup after
 creating checkpoint on Xen.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=wRiPVX2u-SEA:10 a=IkcTkHD0fZMA:10 a=-sTdsVom9iR7ZWCKvasA:9 a=n2dU9LdhXCZDUdYWtp4A:7 a=yNDPfrPXKMDJ0tV6DxpCCLP5AsUA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 23:16 +0000, Brendan Cully wrote:
> I'd like to keep the fast resume option, and expect that it can be
> contained entirely in Xen-specific code. I'll try to get someone to
> look into it here.

Thanks, please put them in contact with Kazuhiro who has already been
looking into this.

> I think fast resume is somewhat orthogonal to the problem of hanging
> on resume, which just sounds like a xen-specific bug in the slow
> path.

The bug on the Xen side is taking the slow path when the suspend was
actually cancelled, which is what the original patch tries to fix.

Or should/could the slow path be able cope either way?

Ian.

-- 
Ian Campbell
Current Noise: Neil Young - Love And War

For every complex problem, there is a solution that is simple, neat, and wrong.
		-- H. L. Mencken

