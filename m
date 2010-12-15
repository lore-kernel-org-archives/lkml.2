Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0LOPfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:35:43 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56075 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0LOPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:35:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66935131"
Date: Wed, 15 Dec 2010 07:35:40 -0800
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
Message-ID: <20101215153540.GA15817@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <1292384961-8851-2-git-send-email-stepanm@codeaurora.org>
 <201012151631.11574.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012151631.11574.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 04:31:11PM +0100, Arnd Bergmann wrote:
> On Wednesday 15 December 2010, Stepan Moskovchenko wrote:

> In this particular case, it's rather confusing, because one would assume
> that MSM8960 is a subset of MSM8X60!

Unfortunately, this is not the case, and I'm not sure what better name
to use for MSM8X60.  The MSM8X60 name covers MSM8260 and MSM8660, but
MSM8960 is quite a bit different.  Any ideas for better names?

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
