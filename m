Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab1CVQwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:52:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36179 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755196Ab1CVQwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:52:50 -0400
Date: Tue, 22 Mar 2011 16:52:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Message-ID: <20110322165248.GF22583@opensource.wolfsonmicro.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com>
 <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024C3B85A5@dbde02.ent.ti.com>
 <20110318123917.GC27129@sirena.org.uk>
 <B85A65D85D7EB246BE421B3FB0FBB593024C47D5EE@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C47D5EE@dbde02.ent.ti.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 03:05:07PM +0530, Nori, Sekhar wrote:
> On Fri, Mar 18, 2011 at 18:09:17, Mark Brown wrote:

> > ...unfortunately conflicts with this - currently all clock API
> > implementations are unique to the platform and there's no way of adding
> > clocks that works over multiple platforms.

> Hmm, I guess I have a limited view of this. We do have drivers which
> use clock API and work across OMAP and DaVinci series of ARM SoCs.
> The clock implementation in this case is under mach-omap and mach-davinci
> respectively.

It's mostly fine from the point of view of using clocks, it's if you're
trying to provide a clock that there's no API you can rely on - the
clock API itself only includes the user side and every platform gets to
provide its own implementation.
