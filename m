Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab1CILzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:55:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64211 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab1CILzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:55:52 -0500
Subject: Re: [PATCH] ASoC: AM3517: Update codec name after multi-component
 update
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, jhnikula@gmail.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de
In-Reply-To: <1299598363-32656-1-git-send-email-abhilash.kv@ti.com>
References: <1299598363-32656-1-git-send-email-abhilash.kv@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 11:55:45 +0000
Message-ID: <1299671745.3360.90.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 21:02 +0530, Abhilash K V wrote:
> The i2c client device name (".2-001a" in this case, including
> the separator period) for the AIC23 codec on the TI AM3517-EVM
> was appended to the codec_name member of am3517evm_dai to
> resolve the names mismatch happening in soc_bind_dai_link(),
> due to which the card was not getting registered.
> 
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> 
> Acked-by: Jarkko Nikula <jhnikula@gmail.com>
> 
> ---

Applied.

Thanks

Liam

