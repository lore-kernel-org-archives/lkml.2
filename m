Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219Ab2JXRro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:47:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44286 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934943Ab2JXRrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <1351089926-32161-5-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-5-git-send-email-lee.jones@linaro.org>
Date: Wed, 24 Oct 2012 19:47:41 +0200
Message-ID: <CACRpkdYxVPxqpYGX2_O65ykipT9zFP5Us0O-DKPK1ePnoVixTQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] ARM: ux500: Specify AMBA Primecell IDs for Nomadik
 I2C in DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Now the Nomadik I2C driver has been converted to an AMBA one, we
> are required to provide the Primecell IDs via platform code. When
> booting with DT enabled these have to be specified in the device
> nodes. We do that here.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I suspect this should go to stable as well.

Yours,
Linus Walleij
