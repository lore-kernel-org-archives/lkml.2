Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2JOMJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:09:06 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:57687 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab2JOMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:09:04 -0400
Message-ID: <507BFCD9.6070302@ti.com>
Date: Mon, 15 Oct 2012 14:08:57 +0200
From: =?ISO-8859-1?Q?P=E9ter_Ujfalusi?= <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Input: twl*-vibra probe cleanups (devm_* conversion)
References: <1339755732-23774-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1339755732-23774-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 06/15/2012 12:22 PM, Peter Ujfalusi wrote:
> Hello,
> 
> Convert the twl4030, twl6040 vibra drivers to use devm_ at probe time to clean
> up the code a bit.
> The twl6040-vibra driver needed bigger change since the ordering of the
> initialization was not correct.

Would it be possible to include this two patch for 3.7-rc2?
I can resend them if you no longer have them.

Thank you,
Péter

> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (2):
>   Input: twl4030-vibra: Convert to use devm_* in probe
>   Input: twl6040-vibra: Code cleanup in probe with devm_* conversion
> 
>  drivers/input/misc/twl4030-vibra.c |    8 +--
>  drivers/input/misc/twl6040-vibra.c |   99 ++++++++++++++++-------------------
>  2 files changed, 47 insertions(+), 60 deletions(-)
> 



