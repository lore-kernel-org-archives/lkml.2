Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab1FAH6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:58:12 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:41609 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636Ab1FAH6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:58:10 -0400
Message-ID: <4DE5F0DB.2050409@stericsson.com>
Date: Wed, 1 Jun 2011 09:57:15 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com>	<alpine.LFD.2.02.1105311236250.3078@ionos>	<4DE51EB7.7010606@stericsson.com> <BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com>
In-Reply-To: <BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 11:18 PM, Linus Walleij wrote:
> Does it work to register the clocksource with say a core_initcall()
> and avoid the header altogether?
I wanted the init to be called from the struct sys_timer init call. 
Mainly because it is really early and it seems to be what others do but 
if we now want to move things out of the platform code it might make 
sense to remove that dependency.
I'll experiment with it during the day and see how it goes.
