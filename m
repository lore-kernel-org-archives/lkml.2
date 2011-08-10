Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1HJXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:16:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50125 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1HJXQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:16:24 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1312277900.2191.1.camel@phoenix>
References: <1312277900.2191.1.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 11 Aug 2011 07:16:04 +0800
Message-ID: <CAF+7xWmOKm4iDFMm8hp6Aa=L3+XBSqu-K-_RHE5ZH_aMQzk4qw@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: tps65023: Remove num_voltages array
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/2 Axel Lin <axel.lin@gmail.com>:
> We can get n_voltages for each regulator from table_len of struct tps_info.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

hi Liam,
Seems this one is also missing.

Regards,
Axel
