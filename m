Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab0HJRYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 13:24:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57372 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab0HJRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 13:24:28 -0400
Subject: Re: [PATCH] regulator: Remove default DEBUG define from TPS6586x
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
In-Reply-To: <1281452533-9341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1281452533-9341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 18:24:22 +0100
Message-ID: <1281461062.3059.154.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 16:02 +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/tps6586x-regulator.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Applied, I guess we can make this the last before a pull request
tomorrow.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

