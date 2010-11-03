Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0KCJHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 05:07:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41213 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0KCJHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:07:44 -0400
Subject: Re: [PATCH] ASoC: Fix snd_soc_register_dais error handling
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1288767885.32421.5.camel@mola>
References: <1288767885.32421.5.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 09:07:40 +0000
Message-ID: <1288775260.3277.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 15:04 +0800, Axel Lin wrote:
> kzalloc for dai may fail at any iteration of the for loop,
> thus properly unregister already registered DAIs before return error.
> 
> The error handling code in snd_soc_register_dais() already ensure all the DAIs
> are unregistered before return error, we can remove the error handling code
> to unregister DAIs in snd_soc_register_codec().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

