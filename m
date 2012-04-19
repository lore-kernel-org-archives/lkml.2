Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2DSRM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:12:56 -0400
Received: from antcom.de ([188.40.178.216]:41583 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab2DSRMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:12:55 -0400
Message-ID: <4F904795.4050505@antcom.de>
Date: Thu, 19 Apr 2012 19:12:53 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: arm@kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Defconfig update for LPC32xx
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm planning to update arch/arm/configs/lpc32xx_defconfig, adjusting to
device tree and new driver options.

Now I wonder if I should (1) just add drivers which are used on the
reference machine (PHYTEC LPC3250 board) or (2) additionally add all
drivers that I have seen together with LPC32xx on other boards also,
which would demonstrate that the same binary kernel runs on all LPC32xx
machines, but increasing kernel size a bit.

I would prefer option (2) but first want to ask for advice.

Thanks in advance,

Roland
