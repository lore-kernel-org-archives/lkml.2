Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2HTFjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:39:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2HTFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:39:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH V5 0/5] clk: mmp: add clock framework for mmp
Date: Mon, 20 Aug 2012 05:39:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com
References: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
In-Reply-To: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208200539.17878.arnd@arndb.de>
X-Provags-ID: V02:K0:fc5WV4VS6nwbi2UynLr6SXGy4JTs64u7nakKQMkTrsG
 t5fhWbbjFJp65vGvDjNcAGoHoq+XOLjpb62WODBp3HZiNxTuqk
 v/uNQduKq9ZD7E/CfGF3RQ6sKGt/C/ZX4gIInpJ6TzIARVzSO0
 qkgeHRsjCQJxTWtmOJlq1iIXjwUxaGnApT5KJbsfiriQTbGqnJ
 sCMbtfuCP2uRBEvJiMi1Fts9KPfEK/IRo3qlvOJcE6zhwo6toX
 /M0ls369XW7hgalH9aSKtyI6ReuN0sbksk+VdNgCqwkmYj+cJG
 KsSJKCafAfxItHEKVjUT6H4XGRvWMuLA9P7ujuXg3jVC3ndTA6
 4cMmnD2eHwwkZAktlzq0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012, Chao Xie wrote:
> 
> From: Chao Xie <chao.xie@marvell.com>
> 
> v1->v2:
> replace __raw_xxx with xxx_relax
> use ioremap to remap the registers. Finaly it will use device tree to
> get the physical address.
> do not use macro to register clocks, and directly call the functions.
> 
> v2->v3:
> pxa910 will have APB extension clock, so some peripharals will have
> clocks in APB extension base.
> change pxa168-pwm to be pxa910-pwm for pxa910. It will fit the current
> pwm driver.
> 
> v3->v4:
> remove addtional clock name definition
> replace left __raw_xxx
> 
> v4->v5:
> change the format of the file
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
