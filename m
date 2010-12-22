Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0LVW0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:26:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44948 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0LVW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:26:08 -0500
Subject: Re: [PATCH] regulator: Make regulator_has_full_constraints a bool
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1292974207-31736-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <>
	 <1292974207-31736-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 22:26:03 +0000
Message-ID: <1293056763.3329.50.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 23:30 +0000, Mark Brown wrote:
> It's a boolean value so use the type.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

