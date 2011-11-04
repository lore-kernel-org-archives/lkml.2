Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1KDVCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:02:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37251 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129Ab1KDVCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:02:43 -0400
Date: Fri, 4 Nov 2011 21:02:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Rajendra Nayak <rnayak@ti.com>, patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/4] Device tree support for regulators
Message-ID: <20111104210241.GB2541@opensource.wolfsonmicro.com>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <20111027090847.GC6641@opensource.wolfsonmicro.com>
 <CAOesGMii8v3DOCjWpuF3=+EVu+-HYGys=7RRgpk+9U=FxTHwOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMii8v3DOCjWpuF3=+EVu+-HYGys=7RRgpk+9U=FxTHwOA@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 01:21:26PM -0700, Olof Johansson wrote:
> On Thu, Oct 27, 2011 at 2:08 AM, Mark Brown

> > Looking at the device bindings I notice that these bindings loose the
> > ability to assign a descriptive name to regulator outputs.  This is
> > really useful for making it easy to tie the code and the schematics
> > together - you can make the runing system use the same name as the
> > schematic.

> That can easily be added by having a output-name property in the
> regulator device node.

Which is pretty much what Rajendra's updated version in response to my
above comment did FWIW.
