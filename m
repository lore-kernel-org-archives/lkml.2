Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030265Ab2CAKFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:05:39 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:61275 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab2CAKFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:05:37 -0500
Message-ID: <4F4F49E1.4020902@atmel.com>
Date: Thu, 01 Mar 2012 11:05:21 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: at91: Error while registering DMA controller in 3.3-rc
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

We currently have a regression on 3.3-rc kernels about the DMA
controller registration.

http://article.gmane.org/gmane.linux.kernel.mmc/13014

This is due to the DMA driver having seen an update during the 3.3 merge
window  but the AT91 device files not having the corresponding
modifications.

Maybe you remember, those modifications where part of the famous AT91
board/device series that was postponed to 3.4 due to a flood of issues...

So now, I would like to know if it is possible to resolve this problem
by queuing the DMA related patches that we have already in
at91/device-board branch to mainline before 3.3-final?

The patches that I am talking about are:

bdad0b9 ARM: at91/dma: remove platform data from DMA controller
and
2756bf5 ARM: at91/dma: DMA controller registering with DT support

I do think it is pretty silly to try to resolve this issue by not taking
those two little patches and modifying source code to workaround this
issue. If we do this, we will get conflicts and need to rework the
already queued 3.4 material.

Do you want me to prepare a new at91-fixes branch with those two patches
or you can take them yourself?

Thanks for your help, best regards,
-- 
Nicolas Ferre
