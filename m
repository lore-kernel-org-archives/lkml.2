Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0H0FmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 01:42:15 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40938 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751235Ab0H0FmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 01:42:12 -0400
Date: Fri, 27 Aug 2010 07:41:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] msm: add gpiomux api for gpio multiplex &
 configuration.
Message-ID: <20100827054155.GA1677@ucw.cz>
References: <1282594368-5791-1-git-send-email-gbean@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282594368-5791-1-git-send-email-gbean@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> +++ b/arch/arm/mach-msm/gpiomux-7x00.h
> @@ -0,0 +1,79 @@
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

GPL, please... and spread the news to the codeaurora people so we
don't get this over and over and over again.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
