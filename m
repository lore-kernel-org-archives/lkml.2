Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab0LPMA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:00:26 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59064 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0LPMAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:00:21 -0500
Subject: Re: [PATCH 1/2] regulator: Factor out voltage set operation into a
 separate function
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Graeme Gregory <dp@xora.org.uk>
In-Reply-To: <1292254707-776-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292254707-776-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 12:00:16 +0000
Message-ID: <1292500816.3285.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 15:38 +0000, Mark Brown wrote:
> Push all the callers of the chip set_voltage() operation out into a single
> function to facilitiate future refactoring.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |   63 ++++++++++++++++++++++++++++-----------------
>  1 files changed, 39 insertions(+), 24 deletions(-)
> 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

