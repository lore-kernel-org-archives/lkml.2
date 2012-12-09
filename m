Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2LIFhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 00:37:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64197 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2LIFhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 00:37:24 -0500
Message-ID: <50C4238F.4050900@debian.org>
Date: Sun, 09 Dec 2012 13:37:19 +0800
From: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.10) Gecko/20121028 Icedove/10.0.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] regulator: anatop: Use linear_min_sel with linear
 mapping
References: <1355011545.3283.1.camel@phoenix>
In-Reply-To: <1355011545.3283.1.camel@phoenix>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 2012年12月09日 08:05, Axel Lin 提到:
> By setting linear_min_sel to anatop_reg->min_bit_val, we can avoid
> adjust the anatop_reg->min_bit_val offset in [set|get]_voltage_sel.
> 
> With this chance we can refactor this driver to use
> regulator_[get|set]_voltage_sel_regmap.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Ying-Chun Liu <paulliu@debian.org>

Looks good to me and I just test the path and it works.


-- 
                                PaulLiu (劉穎駿)
E-mail: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>
