Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0K3AKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:10:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35797 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab0K3AKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:10:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I7wDd2CHzwK/5EhMWSYOQBM5e0XCXvxBIm/apTU8VnB6bqBC2qbqL2HxQkqYfSa0CS
         k9YuWMvBVRXF7aFm8iawO/oJmG41hBKoREQxsAF/q0NNKNK3PbOEFd2gdKRjSpuRvdyE
         y3tMrn6awwpQyXes24mAg38sBs4qSuKVESK8o=
MIME-Version: 1.0
In-Reply-To: <1291071265-4238-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1291071265-4238-1-git-send-email-Dinh.Nguyen@freescale.com>
Date: Mon, 29 Nov 2010 22:10:49 -0200
Message-ID: <AANLkTikbroTO6A=1_nBrO=y-O-MiGgtZAN5tg32+4-c=@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx: Add mx53 changes to crm_regs
From: Fabio Estevam <festevam@gmail.com>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de, eric@eukrea.com,
        u.kleine-koenig@pengutronix.de, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Mon, Nov 29, 2010 at 8:54 PM,  <Dinh.Nguyen@freescale.com> wrote:
...
>
>  /* eSDHC */
> -CLK_GET_RATE(esdhc1, 1, ESDHC1_MSHC1)
> -CLK_SET_PARENT(esdhc1, 1, ESDHC1_MSHC1)
> -CLK_SET_RATE(esdhc1, 1, ESDHC1_MSHC1)
> +CLK_GET_RATE(esdhc1, 1, ESDHC1_MSHC2)
> +CLK_SET_PARENT(esdhc1, 1, ESDHC1_MSHC2)
> +CLK_SET_RATE(esdhc1, 1, ESDHC1_MSHC2)
>
> -CLK_GET_RATE(esdhc2, 1, ESDHC2_MSHC2)
> -CLK_SET_PARENT(esdhc2, 1, ESDHC2_MSHC2)
> -CLK_SET_RATE(esdhc2, 1, ESDHC2_MSHC2)
> +CLK_GET_RATE(esdhc2, 1, ESDHC2_3_MSHC2)
> +CLK_SET_PARENT(esdhc2, 1, ESDHC2_3_MSHC2)
> +CLK_SET_RATE(esdhc2, 1, ESDHC2_3_MSHC2)

Shouldn´t this be part of another patch?

Regards,

Fabio Estevam
