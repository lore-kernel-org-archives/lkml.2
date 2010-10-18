Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0JRKku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:40:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36317 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0JRKks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:40:48 -0400
Date: Mon, 18 Oct 2010 19:39:57 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the s5p tree with the arm tree
In-reply-to: <20101018105046.368420c2.sfr@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jeremy Kerr'" <jeremy.kerr@canonical.com>,
        "'Lorenzo Pieralisi'" <lorenzo.pieralisi@arm.com>,
        "'Jason Wang'" <jason77.wang@gmail.com>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Russell King'" <rmk@arm.linux.org.uk>
Message-id: <048201cb6eb0$d0f2bea0$72d83be0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActuViSStBpa6GSdTXSHZzSbBIWgXAAWmBhQ
References: <20101018105046.368420c2.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen wrote:
> 
> Hi Kukjin,
> 
Hi Stephen,

> Today's linux-next merge of the s5p tree got a conflict in
> arch/arm/mach-s5p6440/include/mach/debug-macro.S between commit
> 08a610d9ef5394525b0328da0162d7b58c982cc4 ("arm: return both physical and
> virtual addresses from addruart") from the arm tree and commit
> 29159b7dd244def6e0073ff0e2d4cbb59599187f ("ARM: S5P64X0: Add S5P64X0
> (S5P6440 and S5P6450) initialization support") from the s5p tree.
> 
> The latter removed the file modified by the former.  I did that.
> 
> The appropriate part of the above arm commit needs to be done for the new
> file arch/arm/mach-s5p64x0/include/mach/debug-macro.S .  Unfortunately, I
> am unqualified to do that ...

I fixed it up and finished test on the board also..if any problems, please
let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

