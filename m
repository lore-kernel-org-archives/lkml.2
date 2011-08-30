Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab1H3AUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 20:20:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1H3AUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 20:20:14 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1314629649.2753.4.camel@phoenix>
References: <1314629649.2753.4.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 30 Aug 2011 08:19:53 +0800
Message-ID: <CAF+7xW=Q0GkZ=Yy-boPdinf8HwrswP6fwuJSONGtg8gLPjNNhQ@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] regulator: tps65023: Remove num_voltages array
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/29 Axel Lin <axel.lin@gmail.com>:
> We can get n_voltages for each regulator from table_len of struct tps_info.
>

hi Liam,
Please ignore this one.
I just found it is already include in
commit  1c3ede05d1 "regulator: tps65023: Setting correct core
regulator for tps65021"

Thanks,
Axel
