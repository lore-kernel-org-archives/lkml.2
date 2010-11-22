Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0KVNnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:43:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46184 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab0KVNnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:43:46 -0500
Subject: Re: [PATCH RESEND] ASoC: stac9766 - set reg_cache_default to
 stac9766_reg
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <1290385254.6941.2.camel@mola>
References: <1290385254.6941.2.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 13:43:36 +0000
Message-ID: <1290433416.3309.20.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 08:20 +0800, Axel Lin wrote:
> Looks like this is missing during multi-component conversion.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This resend fixes the subject line of the patch.
> 
>  sound/soc/codecs/stac9766.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
Both this and alc5263 memory leak fix

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

