Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0LAJx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:53:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52003 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab0LAJx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:53:56 -0500
Subject: Re: [PATCH] ASoC: ak4535: Improve readability for setting mute
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard@openedhand.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1291195354.5563.6.camel@mola>
References: <1291195354.5563.6.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 09:53:52 +0000
Message-ID: <1291197232.3292.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 17:22 +0800, Axel Lin wrote:
> The mute/unmute is controled by SMUTE (Soft Mute Control bit):
>         0: Normal Operation (Default)
>         1: DAC outputs soft-muted
> 
> I think this change improves readability.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

