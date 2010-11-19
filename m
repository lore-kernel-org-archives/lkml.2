Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0KSLKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:10:04 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43308 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab0KSLKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:10:02 -0500
Subject: Re: [PATCH] ASoC: uda134x - set reg_cache_default to uda134x_reg
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Pellegrin <chripell@evolware.org>
In-Reply-To: <1290152886.10001.2.camel@mola>
References: <1290152886.10001.2.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 11:09:56 +0000
Message-ID: <1290164996.3276.3.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 15:48 +0800, Axel Lin wrote:
> After checking the code in 2.6.36,
> I found this is missing during multi-component conversion.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/uda134x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

