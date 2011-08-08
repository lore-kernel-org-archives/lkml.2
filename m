Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1HHQj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:39:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41099 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1HHQj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:39:57 -0400
Subject: Re: [PATCH] regulator: 88pm8607: Fix off-by-one value range
 checking in the case of no id is matched
From: Liam Girdwood <lrg@kernel.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1312445891.5448.1.camel@phoenix>
References: <1312445891.5448.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:39:53 +0100
Message-ID: <1312821593.3316.3.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 16:18 +0800, Axel Lin wrote:
> In the case of no id is matched, the variable i is equal to
> ARRAY_SIZE(pm8607_regulator_info).
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I think compare variable i with ARRAY_SIZE(pm8607_regulator_info) here is slightly
> better in readability than compare with PM8607_ID_RG_MAX.
> Axel
> 

Applied.

Thanks

Liam

