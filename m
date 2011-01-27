Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1A0Jyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 04:54:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36277 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753872Ab1A0Jyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:54:43 -0500
Date: Thu, 27 Jan 2011 09:54:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: halli manjunatha <manjunatha_halli@ti.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] TI WL 128x FM V4L2 driver
Message-ID: <20110127095441.GA1338@opensource.wolfsonmicro.com>
References: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com> <20110125150430.GF13051@sirena.org.uk> <AANLkTi=J6mC7yWL9DF91Tp4+67QpAVK8vTMVVmsfJNyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=J6mC7yWL9DF91Tp4+67QpAVK8vTMVVmsfJNyw@mail.gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 03:02:43PM +0530, halli manjunatha wrote:

Please don't top post: http://daringfireball.net/2007/07/on_top

> This is completely independent of WL 127X driver, instead this driver
> works on top of the shared transport line discipline driver (which is
> at driver/misc/ti-st in mainline).

So what happens when both drivers are in the system?  It sounds like
you've got two different drivers for the same hardware.  There must be
some redundancy there if nothing else.
