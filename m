Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2EEMHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 08:07:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38656 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2EEMH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 08:07:29 -0400
Date: Sat, 5 May 2012 05:06:06 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karl KOMIEROWSKI <karl.komierowski@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
Message-ID: <20120505120605.GB20875@lizard>
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com>
 <F45880696056844FA6A73F415B568C695929A08445@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <F45880696056844FA6A73F415B568C695929A08445@EXDCVYMBSTM006.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 10:42:59AM +0200, Arun MURTHY wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > If no platform data at all is supplied the driver crashes,
> > extend the checks to be more careful so we can compile in the
> > driver and boot also without platform data present.
> > 
> > Cc: Arun Murthy <arun.murthy@stericsson.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> 
> Acked-by: Arun Murthy <arun.murthy@stericsson.com>

Thanks guys, all three patches now applied!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
