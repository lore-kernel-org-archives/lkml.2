Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2FLOt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:49:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2FLOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:49:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 06/14] mfd: Initialise the DB8500 PRCMU driver at core_initcall time
Date: Tue, 12 Jun 2012 14:49:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Samuel Ortiz <sameo@linux.intel.com>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <201206121259.38807.arnd@arndb.de> <4FD742C9.7090603@linaro.org>
In-Reply-To: <4FD742C9.7090603@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206121449.22978.arnd@arndb.de>
X-Provags-ID: V02:K0:FoT1vogn5scv+jkXLLJ19QGzWboIwlGRY91UswhOm/K
 Adztr9J4wNb6F2v4cGhq1joByOh/GgCAzJ0KpyyLnHpjZ9ySf3
 u+x1/8nrLPSLYIEw3zMfXXWJFYt1IxBTjrwM+95iIgPGBeeJdS
 eoCBjIevhGrYKsFqxfvyPKVlxTNoXlyR/PcHKjz78B4j6+Fv/a
 NaXfTWYGs/KAoApA17/sNaJoExjkLSGJQaocoV5hetpUVZ0gcU
 f43woG1ShhW85TdBVooQMG1o5s0oLzZWhH//QJ9x3pFiju9M5Q
 LJPhJiuaIr7NN1QH7Mmzb2q9+l9tU0rkNDN3CBDnf1YPBb8Vm+
 Kero5dSv3rQatII8akpI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2012, Lee Jones wrote:
> But your suggestion above involves some heavy refactoring of how Device 
> Tree works. Meanwhile the ab8500 will not work as an IRQ controller 
> until we either complete the work or use the same solution as we did for 
> the Nomadik GPIO controller. I think for now at least we should continue 
> to work on enablement and leave the 'nice to have's until last. We are 
> doing nothing new here, just bringing the ab8500 IRQ controller into 
> line with the Nomadik one.

Right, I didn't say we should not take your patch, but we should be
aware that it's not the solution we want to use in the long run.

	Arnd
