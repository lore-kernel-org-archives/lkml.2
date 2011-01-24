Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1AXLbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 06:31:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46880 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1AXLbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:31:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Q4pMSuuMJOCAKr2qeRPsyCebOgfY9XYY66ZcfYeNLoIkW86+Qe1BKpTH/QKWjAIhvu
         ZPOyJLc2QsI4sjBo1VtxmL+QAWE6DmHYX7rVLeaFoo/bbv2DK9C0b+fmPWO+Hz5eMgFj
         hQM/2DoqOzstHQiafK6kOm2p3QUIyBOPxfMLw=
MIME-Version: 1.0
In-Reply-To: <1295735888-25527-2-git-send-email-lars@metafoo.de>
References: <1295735888-25527-1-git-send-email-lars@metafoo.de>
	<1295735888-25527-2-git-send-email-lars@metafoo.de>
Date: Mon, 24 Jan 2011 20:31:19 +0900
Message-ID: <AANLkTim2L=ybmFhFXkQ+h_FrqQuMzzt9tHj_+WMgbyN5@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] SoC: Samsung: Fix outdated cpu_dai_name for
 s3c24xx i2s
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, "for 2.6.37" <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 7:38 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> During the multi-component patch the s3c24xx i2s driver was renamed from
> "s3c24xx-i2s" to "s3c24xx-iis", while the sound board drivers were not
> updated to reflect this change as well.
>
> As a result there is no match between the dai_link and the i2s driver and no
> sound card is instantiated.
>
> This patch fixes the problem by updating the sound board drivers to use
> "s3c24xx-iis" for the cpu_dai_name.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: stable@kernel.org (for 2.6.37)

Acked-by: Jassi Brar <jassi.brar@samsung.com>
