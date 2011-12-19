Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1LSWyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:54:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45571 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1LSWym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:54:42 -0500
MIME-Version: 1.0
In-Reply-To: <1324309079-10739-1-git-send-email-marek.vasut@gmail.com>
References: <1324309079-10739-1-git-send-email-marek.vasut@gmail.com>
Date: Tue, 20 Dec 2011 06:54:40 +0800
Message-ID: <CAAQ0ZWRPZP7cPLLdxEsx3QwU0pnxL5jy9a5JjqsOPz_rDp_Oxw@mail.gmail.com>
Subject: Re: [PATCH RESEND] MXSFB: Fix driver registration
From: Shawn Guo <shawn.guo@linaro.org>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        FlorianSchandinat@gmx.de, Wolfgang Denk <wd@denx.de>,
        Stefano Babic <sbabic@denx.de>, Huang Shijie <b32955@freescale.com>,
        Axel Lin <axel.lin@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 December 2011 23:37, Marek Vasut <marek.vasut@gmail.com> wrote:
> The driver should be registered with mxsfb_driver, not with mxsfb_devtype.
> This caused obvious null pointer dereference and crash.
>
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> Cc: Wolfgang Denk <wd@denx.de>
> Cc: Stefano Babic <sbabic@denx.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Huang Shijie <b32955@freescale.com>
> Cc: Axel Lin <axel.lin@gmail.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Acked-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn
