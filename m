Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1LGQav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:30:51 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54432 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab1LGQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:30:49 -0500
Message-ID: <4EDF94B0.1050108@linaro.org>
Date: Thu, 08 Dec 2011 00:30:40 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, eric.miao@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] Regulator: Add Anatop regulator driver
References: <1323265998-29088-1-git-send-email-paul.liu@linaro.org> <1323265998-29088-2-git-send-email-paul.liu@linaro.org> <20111207155457.GB22355@opensource.wolfsonmicro.com>
In-Reply-To: <20111207155457.GB22355@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011年12月07日 23:54), Mark Brown wrote:
> On Wed, Dec 07, 2011 at 09:53:18PM +0800, Ying-Chun Liu (PaulLiu) wrote:
>> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>>
>> Anatop regulator driver is used by i.MX6 SoC. This patch adds the
>> Anatop regulator driver.
> 
> This changelog isn't terribly verbose but looking at the code what
> you've actually got here is a driver that is simply an indirection
> layer for the regulator API and no explanation as to why you're doing
> this.  My first thought is that anything using this driver should just
> be a regulator driver directly.

Hi Mark,

Thanks. I think you are correct. I just search the LKML and found that
this has been discussed already.
https://lkml.org/lkml/2011/10/28/325

So what we should do is forget this patch and use fixed regulators
rather than create an indirection layer.

Many Thanks,
Paul

