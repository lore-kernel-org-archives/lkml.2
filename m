Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab0FUR1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:27:14 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39592 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932312Ab0FUR1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:27:12 -0400
Date: Mon, 21 Jun 2010 19:27:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Gregory Bean <gbean@codeaurora.org>, dwalker@codeaurora.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] msm: Add gpio register address mapping information.
Message-ID: <20100621172704.GH2176@elf.ucw.cz>
References: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
 <1276888375-13221-2-git-send-email-gbean@codeaurora.org>
 <20100619200249.GA2507@elf.ucw.cz>
 <4C1F9B58.6020302@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F9B58.6020302@codeaurora.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-06-21 10:03:20, Bryan Huntsman wrote:
> Pavel Machek wrote:
> >Hi!
> >
> >>--- /dev/null
> >>+++ b/arch/arm/mach-msm/gpio_hw-7x30.h
> >>@@ -0,0 +1,112 @@
> >>+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> >>+ *
> >>+ * Redistribution and use in source and binary forms, with or without
> >>+ * modification, are permitted provided that the following conditions are
> >>+ * met:
> >>+ *     * Redistributions of source code must retain the above copyright
> >>+ *       notice, this list of conditions and the following disclaimer.
> >>+ *     * Redistributions in binary form must reproduce the above
> >>+ *       copyright notice, this list of conditions and the following
> >>+ *       disclaimer in the documentation and/or other materials provided
> >>+ *       with the distribution.
> >>+ *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
> >>+ *       contributors may be used to endorse or promote products derived
> >>+ *       from this software without specific prior written permission.
> >
> >Yeah. Either this can be replaced with GPL, and it such case just do
> >so, or it can not, and then it can not be applied to kernel.
> >
> 
> This is a standard BSD-style license so it's compatible w/ the GPL.
> Thanks.

Not good enough for kernel. Stop trying to push this.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
