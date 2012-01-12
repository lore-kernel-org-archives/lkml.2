Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2ALIku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:40:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57916 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab2ALIkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:40:49 -0500
Date: Thu, 12 Jan 2012 00:40:44 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        "'Liam Girdwood'" <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: s5m8767: Add missing breaks
Message-ID: <20120112084043.GC1176@opensource.wolfsonmicro.com>
References: <1326351429.3471.0.camel@phoenix>
 <027001ccd104$47bdb0b0$d7391210$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <027001ccd104$47bdb0b0$d7391210$@com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 05:29:19PM +0900, Sangbeom Kim wrote:

> During normal test, I can't detect the problem.
> But It should add break to apply proper ramp slope.

Looking at the code you're unlikely to see a problem as the failure will
be to ramp more slowly which will just reduce performance rather than
cause crashes or anything like ramping too quickly can.
