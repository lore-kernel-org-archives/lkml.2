Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2HQLYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:24:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2HQLYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:24:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH V4 1/5] clk: mmp: add mmp specific clocks
Date: Fri, 17 Aug 2012 11:24:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com
References: <1345183330-20244-1-git-send-email-xiechao.mail@gmail.com> <1345183330-20244-2-git-send-email-xiechao.mail@gmail.com>
In-Reply-To: <1345183330-20244-2-git-send-email-xiechao.mail@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171124.39201.arnd@arndb.de>
X-Provags-ID: V02:K0:E2vx1XtkA4FK3dsUamV5DRQkCWuTkj9dyWjggGNWiEe
 NLUeuWFQd5KjCaZsbB08PKYAWiWN7sk1wQE4IHEdrEGnKDtS2I
 SrR2PSVZ4QCZhfsXvF/KZ4brg30O5y5U2RPvpzG/A1GzIsCGDe
 0H5ZBPdeN42P0Ti67AtwU2Xank7z4nI4nzK23A5ybI2xPZ7cyp
 3tOILHqTtGDBWoLCuwx0LwCJJARom3wSa4tVFARVNrQO7bvPul
 uk/2FCzCgZr2yGMHZUdomGJsznTKh2JH7e/oc9tTCjxySJzURH
 vJllFWkXU43SHzklTVM2pXDBvCj2UPd/sP79vhP1fxBAShRdd9
 Gm5kRinx+/Fs0sTx+ZQE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2012, Chao Xie wrote:
> 
> From: Chao Xie <chao.xie@marvell.com>
> 
> add mmp specific clocks including apbc cloks, apmu clocks,
> and pll2, fraction clocks
> 
> Signed-off-by: Chao Xie <xiechao.mail@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
