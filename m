Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2HQLZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:25:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2HQLZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:25:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH V4 5/5] arm: mmp: make all SOCs use common clock by default
Date: Fri, 17 Aug 2012 11:25:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com
References: <1345183330-20244-1-git-send-email-xiechao.mail@gmail.com> <1345183330-20244-6-git-send-email-xiechao.mail@gmail.com>
In-Reply-To: <1345183330-20244-6-git-send-email-xiechao.mail@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171125.36990.arnd@arndb.de>
X-Provags-ID: V02:K0:W7iDx94nxqumpcEBAGblXnLkHQLVBt88XqJLJUmrBSO
 B5q+R6v69bIH1UBDMz72ph0c4JUkC3hq6dzbpBbl1hmBznIb3c
 sPadREv+NwLbZv93FxPRW5niSWdGNztnq56zv4CivDZuFwW0aO
 6fLEdlkBQasXHWWKS3kFYelpgV2aQSlrrqsqvyTFSvPM1yUCUJ
 ex2tXK+SiGRUbZ4YOIT2qBSQ8mmopL0FHqZwBp3ScLJKgyOsMr
 KE9USHIAZUGRFZ2y8eamlpFYiUvaFq0ss8xWBEI7ou4IbOL/QT
 zxVy+2GdcgmaMGW1GMSbpZgyH7gGm51vYdEa0FJkGtlocxONaS
 o0WYf4aDd5lvfpC6WEhs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2012, Chao Xie wrote:
> From: Chao Xie <chao.xie@marvell.com>
> 
> Signed-off-by: Chao Xie <xiechao.mail@gmail.com>
> ---
>  arch/arm/mach-mmp/Kconfig |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
