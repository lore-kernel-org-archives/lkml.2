Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1G1Jam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:30:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57116 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1G1Jag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:30:36 -0400
Subject: Re: [PATCH 1/6] regulator: Fix WM831x regulator ID lookups for
 multiple WM831xs
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 10:30:30 +0100
Message-ID: <1311845430.3283.9.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 22:20 +0100, Mark Brown wrote:
> With multiple wm831x devices the device IDs used for the regulators will
> not always be contiguous so simply taking the modulus is not sufficient
> to look up the ID, we need to reverse the way the ID is generated.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm831x-dcdc.c |   16 ++++++++++++++--
>  drivers/regulator/wm831x-ldo.c  |   25 ++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 5 deletions(-)
> 

All Applied

Thanks

Liam

