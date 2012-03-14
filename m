Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2CNBtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:49:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57988 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab2CNBtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
Date: Wed, 14 Mar 2012 10:49:48 +0900
X-Google-Sender-Auth: RFh9iRktZcD4njCp4VDcCop8JmM
Message-ID: <CAH9JG2VhDKN4skjtgsYXDJqrNbXbOuheKHo_hQPeQ3XdNgh1Lg@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] Updates for exynos4210 and DT-based systems
From: Kyungmin Park <kmpark@infradead.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+CC another i2c subsystem maintainer, Wolfram Sang.

On 3/14/12, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> Changes since v1:
>  - Move unrelated code fragment to separate patch (of_match_ptr())
>  - Move device-type handling to separate function and rework its
>    internals a bit
>
> This patchset reworks i2c-s3c2410 driver a bit to better handle
> device tree-enabled platforms and adds two quirks required by
> exynos4210-specific I2C controller used by s5p-hdmi driver.
>
> This patchset is based on "i2c-bjdooks/for-34/i2c/i2c-samsung" branch
> taken from:
>
>   git://git.fluff.org/bjdooks/linux.git
>
> Karol Lewandowski (3):
>   i2c-s3c2410: Drop unused define
>   i2c-s3c2410: Rework device type handling
>   i2c-s3c2410: Add HDMIPHY quirk for S3C2440
>
>  .../devicetree/bindings/i2c/samsung-i2c.txt        |   10 ++-
>  drivers/i2c/busses/i2c-s3c2410.c                   |   93
> +++++++++++++++-----
>  2 files changed, 77 insertions(+), 26 deletions(-)
>
> --
> 1.7.9
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
