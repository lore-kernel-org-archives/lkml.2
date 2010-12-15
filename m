Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0LOWDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:03:21 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23615 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab0LOWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:03:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66778937"
Date: Wed, 15 Dec 2010 14:03:17 -0800
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
Message-ID: <20101215220317.GA22394@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <201012151631.11574.arnd@arndb.de>
 <20101215153540.GA15817@huya.qualcomm.com>
 <201012151740.24933.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012151740.24933.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 05:40:24PM +0100, Arnd Bergmann wrote:

> My point was really that they should not be exclusive, even if they
> are rather different. If the code is structured in a more modular
> way, you can turn all MSM/QSD options from the "Qualcomm MSM SoC Type"
> choice into separate "bool" config options. You probably don't want
> to do that now for all the existing ones, but I would suggest you
> try not add more to the pile ;-).

It's kind of hard to do too much of this, though, until ARM kernels
can be relocated.  They mostly all live at different base addresses
(and 8960 might also move).  Throw CPU differences into the mix and it
gets messier.

I'm not saying it isn't solvable, but there are a lot of things that
need to be done to get there.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
