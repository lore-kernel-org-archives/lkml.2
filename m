Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2K1OWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:22:12 -0500
Received: from void.printf.net ([89.145.121.20]:36512 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab2K1OWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:22:09 -0500
From: Chris Ball <cjb@laptop.org>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] mmc: core: Add support for idle time BKOPS
References: <1353844588-29281-1-git-send-email-merez@codeaurora.org>
	<cf1cd2d60d084fd97009f0c7091a55ed.squirrel@www.codeaurora.org>
Date: Wed, 28 Nov 2012 09:22:01 -0500
In-Reply-To: <cf1cd2d60d084fd97009f0c7091a55ed.squirrel@www.codeaurora.org>
	(merez@codeaurora.org's message of "Sun, 25 Nov 2012 04:46:38 -0800
	(PST)")
Message-ID: <87pq2x4xkm.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maya,

On Sun, Nov 25 2012, merez@codeaurora.org wrote:
> I managed to find a solution in which there is no need to check the number
> of written / discarded sectors as a trigger for BKOPS status check.
> I moved the code that checks the need to stop the BKOPS to mmc/block code,
> in which there is no need for additional claim_host and remove_host
> operations.
> Please review this patch.

Looks good -- if we find that counting with a bitmask of eraseblocks is
necessary it can be added on later.

Do you have a testing plan for the patch?  I wonder if we could test
the effects on battery life and latency.

Thanks!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
