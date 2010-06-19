Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0FSUB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:01:26 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36598 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756794Ab0FSUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:01:25 -0400
Date: Sat, 19 Jun 2010 22:02:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] msm: Add gpio register address mapping information.
Message-ID: <20100619200249.GA2507@elf.ucw.cz>
References: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
 <1276888375-13221-2-git-send-email-gbean@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276888375-13221-2-git-send-email-gbean@codeaurora.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- /dev/null
> +++ b/arch/arm/mach-msm/gpio_hw-7x30.h
> @@ -0,0 +1,112 @@
> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are
> + * met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above
> + *       copyright notice, this list of conditions and the following
> + *       disclaimer in the documentation and/or other materials provided
> + *       with the distribution.
> + *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
> + *       contributors may be used to endorse or promote products derived
> + *       from this software without specific prior written permission.

Yeah. Either this can be replaced with GPL, and it such case just do
so, or it can not, and then it can not be applied to kernel.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
