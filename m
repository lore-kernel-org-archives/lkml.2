Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2JBLpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:45:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2JBLo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:44:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 00/10] Platform data clean-up and UIB device enablement
Date: Tue, 2 Oct 2012 11:44:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210021144.53559.arnd@arndb.de>
X-Provags-ID: V02:K0:3dM4IshVEUF5VVM01RpO6Z8W0gR2EmBuR9tcEXt2yya
 RU68irMNUhLk5YuaCSAOtd8Sn3k2DwdL2g8vFA8OriR9i6XOSk
 rSq2+sHokIylleA6/ZeqESZZtdkphFmAkolZMGVfDZJykEZTGh
 7x8eBA/wPajpU0UfgBEkx5isa08nw4HslNfV0fyD3tP1YntePC
 dqU1aQhjEpLrAiJ2C/+smkV6by549VPzna+ndSiwCghP0wQGep
 QWFr0wdjzyV4r3v6+tcxwu5XUQau4+bL35IdlorQ9qcrDFotlc
 K9WPG8N8heMRPbNA5s8tcCQlzy+adVT2s7PMX+Yo95i8pIjXlP
 3RNzxdVGJY+EwCTYNFYw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2012, Lee Jones wrote:
> In this patch-set we move all Device Tree start-up code from the u8500
> board file and into the more persistent db8500 cpu file. This will aid
> future endeavours to remove platform code completely from Mainline. We
> also enable some of the devices found on the STUIB (User Interface
> board), which attaches to some of ST-Ericsson's reference platforms.

Looks all good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
