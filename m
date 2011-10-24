Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1JXHLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:11:10 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:57489 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab1JXHLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:11:08 -0400
Message-ID: <4EA50F7F.6000400@st.com>
Date: Mon, 24 Oct 2011 12:40:55 +0530
From: Rajeev kumar <rajeev-dlh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vikram Pandita <vikram.pandita@ti.com>
Subject: Re: [PATCH ] i2c: omap: recover from Bus Busy condition
References: <1319439118-3800-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1319439118-3800-1-git-send-email-shubhrajyoti@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 12:21 PM, Shubhrajyoti D wrote:
> From: Vikram Pandita<vikram.pandita@ti.com>
>
>      In case a peripheral is holding the DATA bus low, provide a 400Khz
>      constant clock output using the TEST register.
>
>      Also soft reset the I2C controller so that there is no stale state
>      left in the HW state machine.
>
>      A WARN_ON() will be generated when a BB timeout happens.
>
> Signed-off-by: Vikram Pandita<vikram.pandita@ti.com>
> Signed-off-by: Shubhrajyoti D<shubhrajyoti@ti.com>
> ---
>   drivers/i2c/busses/i2c-omap.c |   15 +++++++++++++--
>   1 files changed, 13 insertions(+), 2 deletions(-)


Reviewed-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>


~Rajeev
