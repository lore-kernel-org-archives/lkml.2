Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2LIFi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 00:38:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63552 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2LIFiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 00:38:25 -0500
Message-ID: <50C423CC.4030705@debian.org>
Date: Sun, 09 Dec 2012 13:38:20 +0800
From: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.10) Gecko/20121028 Icedove/10.0.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 2/2] regulator: anatop: Use regulator_[get|set]_voltage_sel_regmap
References: <1355011545.3283.1.camel@phoenix> <1355011663.3283.3.camel@phoenix>
In-Reply-To: <1355011663.3283.3.camel@phoenix>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 2012年12月09日 08:07, Axel Lin 提到:
> Call regulator_[get|set]_voltage_sel_regmap instead of open code.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Ying-Chun Liu <paulliu@debian.org>

Looks good to me and I just test the path and it works.

-- 
                                PaulLiu (劉穎駿)
E-mail: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>
