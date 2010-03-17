Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0CQXI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:08:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37221 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0CQXIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:08:55 -0400
Subject: Re: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: axel.lin@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <427d64721003101756j2a5bf502na83ab35de4bc247e@mail.gmail.com>
References: <427d64721003101756j2a5bf502na83ab35de4bc247e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 23:08:56 +0000
Message-ID: <1268867336.3834.24.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 09:56 +0800, axel lin wrote:
> >From 99175ed0f281d54efdaf8eef548077a8f0b4924a Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Thu, 11 Mar 2010 09:50:07 +0800
> Subject: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
> 
> Given x=0,1,2, current implementation of BUCK_VOL_CHANGE_SHIFT(x) returns 0,4,8.
> The correct return value should be 0,4,6.
> This patch fix the logic.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Both Applied with fixes for mailer mangled patches.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

