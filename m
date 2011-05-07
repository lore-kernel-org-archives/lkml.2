Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1EGSFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 14:05:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50122 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab1EGSFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 14:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MZb2WrtdGSoP9dCP1qPavj0lzgnXEtzIJCd+jqi8Or9KrAEulT+7eZQ3MD43IhG5Zj
         HMK+1I04niuhwp0rAXmwbsAvGMdVA513Al7TNHymikMX0gPk0qG/uUFAi754276ZckQI
         F7NTpvi85t71lXQy12mAQXKF5loTX0kuNxg4M=
MIME-Version: 1.0
In-Reply-To: <47964dd140b0d36db6979f6cd945212ae566e60a.1304532833.git.nicolas.ferre@atmel.com>
References: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com>
	<47964dd140b0d36db6979f6cd945212ae566e60a.1304532833.git.nicolas.ferre@atmel.com>
Date: Sat, 7 May 2011 20:05:47 +0200
X-Google-Sender-Auth: iZmEB12HuiegeNuW7xdDQBBlaTo
Message-ID: <BANLkTi=tVoFLgnVUpj6pXOVN4ACsPed2bQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dmaengine: at_hdmac: implement pause and resume in atc_control
From: Linus Walleij <linus.walleij@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/4 Nicolas Ferre <nicolas.ferre@atmel.com>:

> Pause and resume controls are useful for audio devices. This also returns
> correct status from atc_tx_status() in case chan is paused.
>
> Idea from dw_dmac patch by Linus Walleij.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Looks good 2 me!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
