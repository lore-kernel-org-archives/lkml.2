Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2DCABG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 20:01:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38392 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2DCABF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 20:01:05 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <019601cd1126$971508e0$c53f1aa0$@com>
References: <1332130930.26765.2.camel@phoenix> <1332131021.26765.4.camel@phoenix>
 <019601cd1126$971508e0$c53f1aa0$@com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 3 Apr 2012 08:00:42 +0800
Message-ID: <CAF+7xWnqL1RCTt5cuaVY+MYzjJSZM-=+3nhPdekCurcOV9yOpw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/4] regulator: Rework s5m8767_set_voltage to support
 both LDOs and BUCKs
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Axel
> Basically, Your optimization code looks good.
> But, S5M8767A support 9 Bucks.
> Please Add #9 Buck handling too.
Current code does hand #9 buck in s5m8767_set_voltage().

> As you know, 3.4-rc1 is released.
> Please rebase your patch on 3.4-rc1.
> Some feature is added on 3.4-rc1.
I just try to apply the patch to Mark's for-next tree and linux-next tree.
It looks ok. So I think no need to re-generate the patch.

Regards,
Axel
