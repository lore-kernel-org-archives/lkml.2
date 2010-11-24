Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0KXKsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:48:38 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64936 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0KXKsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:48:37 -0500
Subject: Re: [PATCH 1/2] ASoC: wm8961 - clear WM8961_DACSLOPE bit for
 normal mode
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1290565233.5506.2.camel@mola>
References: <1290565233.5506.2.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 10:48:32 +0000
Message-ID: <1290595712.3332.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 10:20 +0800, Axel Lin wrote:
> DACSLOPE bit of Register 06h ADC and DAC Control 2:
>         0: Normal mode
>         1: Sloping stop-band mode
> 
> Thus in the case of normal mode, we should clear DACSLOPE bit.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Both

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

