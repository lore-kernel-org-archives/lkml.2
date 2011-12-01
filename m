Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1LAMhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:37:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57258 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1LAMhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:37:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [GIT PULL] msm misc changes for 3.3
Date: Thu, 1 Dec 2011 12:37:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20111130233626.GA26687@huya.qualcomm.com>
In-Reply-To: <20111130233626.GA26687@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011237.21297.arnd@arndb.de>
X-Provags-ID: V02:K0:Ojbr7qQKu0LmzvisNwvJzHEoC8KFAS11aTS4mhbpQXr
 r0K0+jDMF2m0SQDWVu9u2eHSes0DW+upOF8Q2P1p3nOen8mA00
 Wcjg9CDQeZMhcqaoxdBfDxrfn++Y7VQvHHl2c0KO3iXKtjN9qL
 N5S8yleeowqzJpRu/agR4WWl+NeArKUQGFwFrzcsvQZTG+jzhU
 WdGtlja6aAeL+EZXYOWCurKA0CEw/xm2oPfnDht9SlaBJnF3A5
 Xc0izz+KqIAIr8TR2roHwErwnFADfddHjdOk5QxMoccbrWzfqz
 7A2mwMkceJXWkHXQHCuhZ0TXcPhs+Wh11iQvRFAjAbNrGNcRG3
 DMQH4w7HG38tMVN0rzXs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 November 2011, David Brown wrote:
> The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:
> 
>   Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)
> 
> are available in the git repository at:
>   git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-misc
> 
> Stephen Boyd (3):
>       ARM: msm: Consolidate and move DEBUG_LL to DEBUG_LL choice
>       msm: Support DEBUG_LL on MSM8660 and MSM8960
>       msm: platsmp: Mark ioremapped memory as __iomem

Applied to next/cleanup, thanks!

	Arnd
