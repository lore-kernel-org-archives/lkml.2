Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1DGH6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:58:52 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:37564 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635Ab1DGH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:58:49 -0400
Message-ID: <4D9D676E.6090608@stericsson.com>
Date: Thu, 7 Apr 2011 09:27:42 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 1/3] ARM: Translate delay.S into (mostly) C
References: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org>	<1302047800-26720-2-git-send-email-sboyd@codeaurora.org> <4D9C2910.6020309@stericsson.com> <4D9D12FD.6060608@codeaurora.org>
In-Reply-To: <4D9D12FD.6060608@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 03:27 AM, Saravana Kannan wrote:
> Isn't this a big in the existing code too? I would prefer not combining
> that with this patch series. That bug should be fixed before/after this
> patch series. Not as part of it.
>
> I would vote for after this patch series since this patch series has
> been trying to get in for quite a while now.
Ok for me.
Leave it as is and I'll send a patch on top of it.

Yours,
Mattias Wallin
