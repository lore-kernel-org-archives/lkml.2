Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab1GDQMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:12:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58724 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1GDQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:12:47 -0400
Subject: Re: [PATCH] regulator: Add basic per consumer debugfs
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1308486796-10065-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1308486796-10065-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 17:12:34 +0100
Message-ID: <1309795954.3272.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-19 at 13:33 +0100, Mark Brown wrote:
> Report the requested load and voltage for each consumer in debugfs when it
> is enabled.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |   30 +++++++++++++++++++++++++++++-
>  1 files changed, 29 insertions(+), 1 deletions(-)
> 

Applied.

Thanks

Liam

