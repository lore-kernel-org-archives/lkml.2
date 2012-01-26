Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2AZL5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:57:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54699 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab2AZL5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:57:47 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3E38@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812CD3E38@EXMAIL03.scwf.nsc.com>
Date: Thu, 26 Jan 2012 12:57:47 +0100
Message-ID: <CACRpkdYjQh8QaRTN3aM1c7MtmcgZNhhq+gXX7vAb9G1471zUOg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] leds-lm3530: replace 'pltfm' with 'pdata'
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 2:51 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> Use 'pdata' rather than 'pltfm' in lm3530_init_registers().
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
