Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2DSRVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:21:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab2DSRVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:21:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Date: Thu, 19 Apr 2012 16:24:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        Huang Shijie <b32955@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de> <20120418090551.GA30966@shlinux2.ap.freescale.net> <20120418092019.GB2232@pengutronix.de>
In-Reply-To: <20120418092019.GB2232@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204191624.53976.arnd@arndb.de>
X-Provags-ID: V02:K0:PMw7QUdn0vB2urgsMV6/QNZvxIb5lPq5a62cdvIY5VK
 ScMVVkycDRkJf3BDrGP/abrW0xRy/JNda/CqZmkToaT8gwdfMw
 yKUubHF0MXff/MauTlBIer+Y8zLsJfoA9knTQZ5FjyOPxWHOZE
 XMdxbcvpApvUDOO4h35sJuSb1vJimzUdhzTaOFjaLJo5aRhl05
 vFkkY1xoBohuIyihuPGD1aOzwgVmZgc96LD7GHkwGcYGYTEWEO
 viAzrpbaExJDgrD6KF5Ov6IhXKy06D11VcGlJm+sm0WiXedzzx
 IZGzudn1YwtAd6H4Xh9vb4hT9vPtaN287V8BeRSbg/HEgar/So
 lPNI/+jb/ztuY5PD2HqI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2012, Wolfram Sang wrote:
> > 
> > I'm converting mxs-dma driver to be mach-independent which also needs
> > this patch.
> > 
> > Do you know when this will be merged?
> 
> Nope. I assumed it could go in via arm-soc, since it makes sense and
> Arnd used to comment this series. He is probably busy, currently.

I think that's fine to go in arm-soc, please send a pull request for this.

	Arnd
