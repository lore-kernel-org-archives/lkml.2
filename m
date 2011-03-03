Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab1CCKUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:20:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46906 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1CCKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:20:32 -0500
Subject: Re: [PATCH] regulator: Convert WM831x regulators to genirq
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1298998243-12177-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1298998243-12177-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 10:20:26 +0000
Message-ID: <1299147627.3337.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 16:50 +0000, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm831x-dcdc.c  |   26 +++++++++++---------------
>  drivers/regulator/wm831x-isink.c |    8 +++-----
>  drivers/regulator/wm831x-ldo.c   |   17 +++++++----------
>  3 files changed, 21 insertions(+), 30 deletions(-)
> 

Applied.

Thanks

Liam

