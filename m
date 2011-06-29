Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab1F2UxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:53:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40191 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751584Ab1F2UxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:53:12 -0400
Date: Wed, 29 Jun 2011 10:48:26 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: alsa-devel@alsa-project.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 2/5] ASoC: atmel-ssc: add phybase in device structure
Message-ID: <20110629174822.GB13051@opensource.wolfsonmicro.com>
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com>
 <a128473d585314a01420a5869949065a549119e3.1309368631.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a128473d585314a01420a5869949065a549119e3.1309368631.git.nicolas.ferre@atmel.com>
X-Cookie: Chicken Little was right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 08:00:16PM +0200, Nicolas Ferre wrote:

>  struct ssc_device {
>  	struct list_head	list;
> +	resource_size_t		phybase;

The type here looks rather wrong?
