Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1AYBFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:05:25 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46924 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1AYBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:05:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71619301"
From: David Brown <davidb@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msm: serial: Add MSM8960 serial support
In-Reply-To: <1295663921-32723-1-git-send-email-stepanm@codeaurora.org>
	(Stepan Moskovchenko's message of "Fri, 21 Jan 2011 18:38:41 -0800")
References: <1295663921-32723-1-git-send-email-stepanm@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110125:linux-arm-msm@vger.kernel.org::NNmyrnwFTl/EWxBc:000000000000000000000000000000000GMB
X-Hashcash: 1:20:110125:linux-arm-kernel@lists.infradead.org:://EQ/fnWMzavlxBj:00000000000000000000000001GsJ
X-Hashcash: 1:20:110125:linux-kernel@vger.kernel.org::qX2BDXmCH//5ukAe:0000000000000000000000000000000001om1
X-Hashcash: 1:20:110125:stepanm@codeaurora.org::DKv1v5PeUyQRmL9O:00000000000000000000000000000000000000033WO
Date: Mon, 24 Jan 2011 17:05:22 -0800
Message-ID: <8yar5c1hjxp.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21 2011, Stepan Moskovchenko wrote:

> diff --git a/arch/arm/mach-msm/devices-msm8960.c b/arch/arm/mach-msm/devices-msm8960.c
> new file mode 100644
> index 0000000..821e6d1
> --- /dev/null
> +++ b/arch/arm/mach-msm/devices-msm8960.c
> @@ -0,0 +1,83 @@
> +/*
> + * Copyright (C) 2008 Google, Inc.
> + * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.

What is the general consenus on this kind of copyright.  Stepan started
with a file with a Google copyright on it, but has largely rewritten the
file to support the new board.  Should we be keeping the copyright from
the file?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
