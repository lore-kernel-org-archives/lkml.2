Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab2JSPa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:30:28 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40717 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914Ab2JSPaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:30:24 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaNK5+5oQNmmyyF+bD=jJYXbHAJF6e8Xn3jtcR4hoXwrw@mail.gmail.com>
References: <1350415376-3217-1-git-send-email-linus.walleij@linaro.org>
	<20121018062208.GB4513@S2101-09.ap.freescale.net>
	<CACRpkdaNK5+5oQNmmyyF+bD=jJYXbHAJF6e8Xn3jtcR4hoXwrw@mail.gmail.com>
Date: Fri, 19 Oct 2012 23:30:23 +0800
Message-ID: <CAAQ0ZWRpgVLcXLygKgeAONC1Yd2UOJu14c7LtF=PtTSbtck_6g@mail.gmail.com>
Subject: Re: [PATCH 4/7] gpio/mxs: convert to use linear irqdomain
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2012 18:22, Linus Walleij <linus.walleij@linaro.org> wrote:
> No, which defconfig shall I use for this driver?
>
mxs_defconfig

Shawn
