Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0FYJLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:11:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41497 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0FYJLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E0kZCWHh8CT9VbGfCpDW8CrM8jIKHOrzyMbYW5zaI/u2CeSISFNpqIXPkVZoEHnd7T
         Atxw0Ntcae0Eu+WcKYFf7/TjmssIXVkU+no7YPGGPBgz3OQNAaUTUcOS9TYKjXLIr3+3
         q2TiAkzX4hIJdpX1zD1lKfoWK/TitO588Q9E4=
Date: Fri, 25 Jun 2010 02:11:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/5 V7] input: STMPE touch controller support
Message-ID: <20100625091116.GE8546@core.coreip.homeip.net>
References: <20100624162407.GA18899@core.coreip.homeip.net>
 <1277455071-8572-1-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277455071-8572-1-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 10:37:51AM +0200, Luotao Fu wrote:
> +
> +	/* 

Trailing whitespace.

> +	 * touch_det sometimes get desasserted or just get stuck. This appears
> +	 * to be a silicon bug, We still have to clearify this with the
> +	 * manufacture. As a workaround We release the key anyway if the
> +	 * touch_det keeps coming in after 4ms, while the FIFO contains no value
> +	 * during the whole time. 

Trailing whitespace.

> +
> +static int stmpe_init_hw(struct stmpe_touch *ts)

__devinit.

Otherwise:

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

I assume it will be merged through MFD tree?

-- 
Dmitry
