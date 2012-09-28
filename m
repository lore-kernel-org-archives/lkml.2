Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab2I1Kwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:52:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59969 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247Ab2I1Kwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:52:40 -0400
Date: Fri, 28 Sep 2012 11:52:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out
 common code
Message-ID: <20120928105238.GD30869@opensource.wolfsonmicro.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
 <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com>
 <20120925192048.GA17038@sirena.org.uk>
 <20120926145615.GJ10147@mail.gnudd.com>
 <20120926150429.GQ4428@opensource.wolfsonmicro.com>
 <20120926163145.GK10147@mail.gnudd.com>
 <20120926164932.GS4428@opensource.wolfsonmicro.com>
 <20120927134110.GD6799@mail.gnudd.com>
 <20120927134919.GW4428@opensource.wolfsonmicro.com>
 <20120928084303.GB22500@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928084303.GB22500@mail.gnudd.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:43:03AM +0200, Davide Ciminaghi wrote:

> 1. Regmap patch for overriding lock/unlock functions
> 2. Regmap based reimplementation of sta2x11-mfd (using sta2x11 special
>    lock/unlock functions).
> 3. Submission of sta2x11 common clock framework as is (using the current
>    version of the clock framework helpers, no regmap).
> 4. Patches for some amba drivers to get them to work on sta2x11.
> 5. Regmap related patches for the common clock framework.

> Does this sound reasonable ?

Makes sense.
