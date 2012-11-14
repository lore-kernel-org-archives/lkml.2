Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422745Ab2KNL7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:59:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57850 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422696Ab2KNL6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:58:40 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [PATCH 0/3] pwm: lpc32xx - Various small fixes
Date: Wed, 14 Nov 2012 12:58:12 +0100
Message-Id: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V02:K0:w82VfBow26jsncvzeL94idwf9f56PsULLI/IDFvTt0D
 WJOznuddhFEWQmGlsm+0RyNedbHAgz6erH1+lJS7QQ0uk7ZTHn
 juUAefqs9SGFYwrfTr8GNJH1/suJPKfw8pjqdl4cXwSMTIdJon
 5ZPO161yGVbIzipoVfbHafZA3hoZalqETGLClHPX6VIW+dBW8l
 UvpnvFAW6j3CK7LKVRaNpJtY9/KLmraMLv6uKf4KorW5dqDiFo
 fY5Y9lQ/2mZmVCGQve3ysSPyUxMQ+2yPAPEfO+xWeOSkEGp4Ug
 z8Uf1UH0AsZjQdyXj2B40PzWTz0uCcmUf+9xWPKrbaucFkpGpk
 mmPv3I9NsKEu+jmaMIAFwEXU9KuE/BJTjvZLMzL0xPbhfZ/m5e
 BZ/6tTbl2Ys+nOCdxm8D3jhjNJjiToQZxVSUGZvINUyuaYB+bS
 eEFHy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few fixes for the LPC32 PWM driver:

* [PATCH 1/3] pwm: lpc32xx - Fix the PWM polarity
* [PATCH 2/3] pwm: lpc32xx - Properly disable the clock on device remove
* [PATCH 3/3] pwm: lpc32xx - Set the chip base for dynamic allocation

Alban
