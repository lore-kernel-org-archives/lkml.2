Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1ILCS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 22:18:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44100 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1ILCSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 22:18:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6466"; a="117466126"
Message-ID: <4E6D6C0D.60100@codeaurora.org>
Date: Sun, 11 Sep 2011 19:18:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
References: <20110912120501.764336af05069fa23a371b5e@canb.auug.org.au>
In-Reply-To: <20110912120501.764336af05069fa23a371b5e@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/11 19:05, Stephen Rothwell wrote:
> Hi Arnd,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-msm/board-msm8x60.c between commit 9e775ad19f52 ("ARM:
> 7012/1: Set proper TEXT_OFFSET for newer MSMs") from the arm tree and
> commit 56e2d8a68803 ("ARM: msm: Add devicetree support for msm8660-surf")
> from the arm-soc tree.
>
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

The device tree machine description also needs to have the .fixup and
.reserve callbacks added to it so that the device tree machines boot
properly. Perhaps the soc tree needs to pull in Russell's tree at some
point to resolve this subtle logical conflict or when the trees are
merged together someone will need to do an evil merge and add the
callbacks in the merge commit.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

