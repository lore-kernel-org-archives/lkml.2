Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0HGJqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 05:46:43 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:58230 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab0HGJql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 05:46:41 -0400
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] regulator: max1586 - fix a memory leak in max1586_pmic_remove()
References: <1281072795.24426.3.camel@mola>
From: Robert Jarzmik <robert.jarzmik@free.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 07 Aug 2010 11:46:32 +0200
In-Reply-To: <1281072795.24426.3.camel@mola> (Axel Lin's message of "Fri\, 06 Aug 2010 13\:33\:15 +0800")
Message-ID: <87wrs2wy9z.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

> In max1586_pmic_probe(), we allocate memory for max1586.
> In max1586_pmic_remove(), current implementation only free rdev
> which is a member of struct max1586_data.
> Thus, there is a small memory leak when we unload the module.
>
> This patch fixes the memory leak by passing max1586 to i2c clientdata,
> and properly kfree(max1586) in max1586_pmic_remove().
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
