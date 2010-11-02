Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0KBBwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:52:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0KBBwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K53ksQxauEYht2aZYFgGebstfpxu1Ylwqj1AFH4JgG7Q2pln+IMFDjDXT0NWqhvjnv
         ksQrU1aQVns9jawrobKTA6tUFdWtKigtQD/k+WA3iYMS4jx1f4MNuh8fu7VMvgHIeaBI
         WkkbNXAWr6zps1+yoUexrR215NhAbahKBA1Qw=
MIME-Version: 1.0
In-Reply-To: <1288635611-25560-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1288635611-25560-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Mon, 1 Nov 2010 23:52:04 -0200
Message-ID: <AANLkTikzEdgUqVU0N=y7Vy+fnqKyskVp6p0zMpdYmenk@mail.gmail.com>
Subject: Re: [PATCH] mfd: Add initial WM8958 support
From: Thiago Farina <tfransosi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 4:20 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
> index de79bae..3fd3684 100644
> --- a/include/linux/mfd/wm8994/core.h
> +++ b/include/linux/mfd/wm8994/core.h
> @@ -17,6 +17,11 @@
>
>  #include <linux/interrupt.h>
>
> +enum wm8994_type {
> +       WM8994 = 0,
> +       WM8958 = 1,
> +};
> +
Don't need to initialize with = 0 and with = 1. This is done by default.
