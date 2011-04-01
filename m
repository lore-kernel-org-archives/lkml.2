Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1DAMPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 08:15:22 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:51944 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab1DAMPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 08:15:19 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
In-Reply-To: <201104011407.20716.arnd@arndb.de>
References: <201103301906.42429.arnd@arndb.de>
	 <201104011322.44729.arnd@arndb.de> <1301658919.27593.72.camel@deskari>
	 <201104011407.20716.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 15:15:14 +0300
Message-ID: <1301660114.27593.95.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 14:07 +0200, Arnd Bergmann wrote:
> On Friday 01 April 2011, Tomi Valkeinen wrote:
> > Thanks for pointing me to the MCDE stuff. I doesn't seem to be merged,
> > though. I need to contact them and see if they're still interested in
> > working on the common interface.
> 
> I pushed back quite hard on some of the aspects there, which probably
> prevented it from going in so far. If the code is as much based on
> the OMAP DSS as I think, quite a number of changes are required to
> both in order to get them into shape for a decent cross-platform layer,
> but there should not be any fundamental issues.

I only looked it briefly, but I'm not sure if there's that much code
that could be common. But I need to read the mail thread properly.

The driver for the display HW on the SoC doesn't probably have anything
in common with OMAP one. What could and should be common is the panel
side, which was just a single patch in that patch set.

 Tomi


