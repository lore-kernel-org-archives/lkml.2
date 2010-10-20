Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0JTVPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:15:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44450 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0JTVPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=kj862ZxpqPo/DmrDmq5Hbw6AcvrlfHs8rtP6y0Okvazk2c5T6BadNMn/jkxuM9qdJi
         J0EiGQSQ64PldAWs5uMPRet6KT1vSdC8V6tC3w0iX8DZ95RonNRxbdUo9N9rLiI1ksuR
         9rUuFkelsNzfdBoXglIn5jSA4u86uTeMu2rQE=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexey Charkov <alchark@gmail.com>
Subject: Re: [PATCH 3/6] input: Add support for VIA VT8500 and compatibles in i8042
Date: Wed, 20 Oct 2010 14:15:07 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8+; KDE/4.4.5; x86_64; ; )
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1287608139-21354-1-git-send-email-alchark@gmail.com> <1287608139-21354-3-git-send-email-alchark@gmail.com>
In-Reply-To: <1287608139-21354-3-git-send-email-alchark@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010201415.09535.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 20, 2010 01:55:35 pm Alexey Charkov wrote:
> VIA and WonderMedia Systems-on-Chip feature a standard i8042-compatible
> keyboard and mouse controller. This adds necessary glue to enable use
> of the standard driver with these systems.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> ---
> 
> Please review and state whether this could be acceptable for a merge
> to mainline in the coming 2.6.37 window. If possible, I would deeply
> appreciate a merge to a relevant git tree for integration prior to
> asking Linus to pull the changes. I could rebase the code if needed,
> currently this is against Linus' master branch.
> 
> This patch relies on the basic architecture support for VT8500/WM8505
> to be in place, as introduced by PATCH 1/6 in this series.

What tree this code will be coming through through?

> +
> +static inline int i8042_platform_init(void)
> +{
> +	i8042_reset = 1;

= true; - it's a boolean.

> +	regbase = ioremap(VT8500_PS2_BASE, SZ_1K);

Error handling?

Thanks.

-- 
Dmitry
