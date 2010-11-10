Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0KJVTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:19:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34215 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab0KJVTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:19:51 -0500
Subject: Re: [PATCH] regulator: enable supply regulator only when use count
 is zero
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
In-Reply-To: <1289383582-10183-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1289383582-10183-1-git-send-email-bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 21:19:46 +0000
Message-ID: <1289423986.3284.56.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 11:06 +0100, Bengt Jonsson wrote:
> Supply regulators are disabled only when the last
> reference count is removed on the child regulator
> (the use count goes from 1 to 0). This patch changes
> the behaviour of enable so the supply regulator is
> enabled only when the use count of the child
> regulator goes from 0 to 1.
> 
> Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

