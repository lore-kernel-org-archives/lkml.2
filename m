Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab1BFJx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 04:53:58 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42151 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750900Ab1BFJx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 04:53:57 -0500
Date: Fri, 4 Feb 2011 14:36:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110204133556.GA2803@ucw.cz>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu 2011-01-20 12:32:38, Daniel Walker wrote:
> This series adds basic Nexus One support which includes a booting
> kernel, and functional MMC .
> 
> Most people won't be able to use this yet unfortunately because
> you need a serial cable to get any output. However, it's a start.

>   msm: mahimahi: add mahimahi board file
>   msm: mahimahi: add in mmc support code
>   msm: mahimahi: add gpio pin muxing code
>   msm: mahimahi: initialize mmc at start up

Even you call the machine Nexus One... can  you be a tiny bit more
consistent with it?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
