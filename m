Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1ASMrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:47:20 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:53430 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279Ab1ASMrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:47:19 -0500
Message-ID: <4D36DD32.7000507@stericsson.com>
Date: Wed, 19 Jan 2011 13:46:42 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] leds: add driver for LM3530 ALS
References: <1295413341-30276-1-git-send-email-shreshthakumar.sahu@stericsson.com>
In-Reply-To: <1295413341-30276-1-git-send-email-shreshthakumar.sahu@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 06:02 AM, Shreshtha Kumar Sahu wrote:
> simple backlight driver for National Semiconductor LM3530.
> Presently only manual mode is supported, PWM and ALS support
> to be added.
>
> Cc: rpurdie@rpsys.net
> Signed-off-by: Shreshtha Kumar Sahu<shreshthakumar.sahu@stericsson.com>
>    

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Richard, once/if you're satisfied with the code could you give
me an Acked-by, and I'll attempt to merge this through the
ux500-core and ARM tree.

Thanks,
Linus Walleij
