Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0GWLFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:05:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45079 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab0GWLFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RR4uO7ID6/t9jB5zPWZjsyTkh7v26sMDZ3+mdxLpIzonx1VOSGESCnGX9KxTxTjG68
         +N6pn9Ao52abEo1aVeqmG6CqVtvVe7+IioQ7hFOg8TTWyKxil9rkBGvzoh7JrRPrydva
         2LWO99/ZHDuWk/va/RYvb1wG/mY0Zts68KlVI=
MIME-Version: 1.0
In-Reply-To: <4C4555DA.40203@renesas.com>
References: <4C4555DA.40203@renesas.com>
Date: Fri, 23 Jul 2010 20:05:50 +0900
Message-ID: <AANLkTikVm-GWq6vun-AjqLJ1L7Y+s28CdDJqmCEX4+2R@mail.gmail.com>
Subject: Re: [PATCH] tmio_mmc: Allow 2 byte requests in 4-bit mode
From: Magnus Damm <magnus.damm@gmail.com>
To: Yusuke Goda <yusuke.goda.sx@renesas.com>
Cc: ian@mnementh.co.uk, damm@opensource.se, sameo@linux.intel.com,
        Paul Mundt <lethal@linux-sh.org>, g.liakhovetski@gmx.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/20 Yusuke Goda <yusuke.goda.sx@renesas.com>:
> Adjust the tmio_mmc block size check to accept 2-byte requests in 4-bit mode.
> Tested with the SDHI hardware block included in sh7724.
>
> Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>

With this patch applied I can use SDIO cards in polling mode with the
tmio-mmc driver. Tested with the SDHI hardware block on sh7372 using
the b43 driver and BCM4318 hardware and the unfortunately out-of-tree
AR6002 "android" driver.

Acked-by: Magnus Damm <damm@opensource.se>
