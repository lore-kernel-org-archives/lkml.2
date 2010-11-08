Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0KHJRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:17:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65221 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0KHJRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:17:00 -0500
Subject: Re: [PATCH] ASoC: Return proper error if snd_soc_register_dais
 fails in psc_i2s_of_probe
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1289193898.682.3.camel@mola>
References: <1289193898.682.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 09:16:56 +0000
Message-ID: <1289207816.3288.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 13:24 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/fsl/mpc5200_psc_i2s.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

