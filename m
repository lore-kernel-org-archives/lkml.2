Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1GVKf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:35:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45720 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1GVKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:35:56 -0400
Subject: Re: [PATCH] regulator: TWL: Remove entry of RES_ID for 6030 macros
From: Liam Girdwood <lrg@kernel.org>
To: Ambresh K <ambresh@ti.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1310263341-29620-1-git-send-email-ambresh@ti.com>
References: <1310263341-29620-1-git-send-email-ambresh@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 11:35:51 +0100
Message-ID: <1311330951.3312.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-09 at 19:02 -0700, Ambresh K wrote:
> From: Ambresh K <ambresh@ti.com>
> 
> RES_ID is only used in 4030, to send PBM singular message to control
> the state of dedicated resources. In 6030, we don't have concept of PBM,
> hence removing the definition of RES_ID (num) from macros.
> 
> Signed-off-by: Ambresh K <ambresh@ti.com>
> ---
>  drivers/regulator/twl-regulator.c |   64 +++++++++++++++++-------------------
>  1 files changed, 30 insertions(+), 34 deletions(-)
> 

Applied.

Thanks

Liam

