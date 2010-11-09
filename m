Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0KIVLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:11:46 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57207 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab0KIVLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:11:44 -0500
Subject: Re: [PATCH] regulator: enable supply regulator only when use count
 is zero
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
In-Reply-To: <1289314226-986-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1289314226-986-1-git-send-email-bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 21:11:38 +0000
Message-ID: <1289337098.3290.35.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 15:50 +0100, Bengt Jonsson wrote:
> Supply regulators are disabled only when the last
> reference count is removed on the child regulator
> (the use count goes from 1 to 0). This patch changes
> the behaviour of enable so the supply regulator is
> enabled only when the use count of the child
> regulator goes from 0 to 1.
> 
> Change-Id: Ic322801119fefaabc1ed4fef248e463e67fb1857
> Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/regulator/core.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 

This doesn't apply to voltage for-next.

Could you please redo.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

