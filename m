Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1H1Qui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 12:50:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51020 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1H1Qud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 12:50:33 -0400
Subject: Re: [PATCH] regulator: Add debugfs file showing the supply map
 table
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1314117550-6663-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1314117550-6663-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Aug 2011 17:50:29 +0100
Message-ID: <1314550229.3666.8.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 17:39 +0100, Mark Brown wrote:
> Useful for working out why things aren't getting plugged together properly.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |   41 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

