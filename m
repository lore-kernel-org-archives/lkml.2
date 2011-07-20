Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1GTVGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:06:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1GTVGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:06:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MSM fix
Date: Wed, 20 Jul 2011 23:06:15 +0200
Message-ID: <1989166.1WcWHOXyl7@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <20110720203703.GA4495@huya.qualcomm.com>
References: <20110720203703.GA4495@huya.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uV8kbXsj65DD7oVAMcC+leV+xixuK5S7f8wQ3hXBSS5
 dXQtKqNtFegktdcT8cPipBMq19dY/eUlMeVwPN1Bm8WY8B6YBs
 rPiMsGA7PBoyqYOG3idqKqxSWmfTEvOJSEV+GldthZZo/k5vzL
 gSsGfO9DfNm9BoT7znVnXONt/BxIWGTZLUkPsthQ7yjRJy2rGI
 zpF6L2a6P00O6yY5Qc/Ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 July 2011 13:37:03 David Brown wrote:
> I seem to have missed this fix when it was sent out in April.
> 
> The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:
> 
>   Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)
> 
> are available in the git repository at:
>   git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-fix
> 
> Jeff Ohlstein (1):
>       msm: platsmp: actually read core count in get_core_count
> 

Hmm, this one seems like it really applies to older kernels as well, so
we can just as well add a cc:stable@kernel.org tag and put it into the
arm-soc/next/fixes branch, right?

Linus has just pulled the 'last arm-soc fixes for 3.0' branch, and I don't
really want to follow up with 'last fix, this time for real' pull request
unless it's for a serious regression.

On a related topic, what's the deal with the msm-core and msm-move-gpio
branches in the same tree? I have the impression that they should be
in arm-soc.git, but I never received a pull request.

The msm-move-gpio branch looks like it wasn't merged into the gpio
tree either, which would be the other logical place, and the msm-core
branch is currently in linux-next but hasn't been updated since April.

	Arnd
