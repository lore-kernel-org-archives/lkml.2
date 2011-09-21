Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1IUKyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:54:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34706 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1IUKyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:54:04 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B73216C5@HQMAIL01.nvidia.com>
References: <1316175182-10700-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B73216C5@HQMAIL01.nvidia.com>
Date: Wed, 21 Sep 2011 12:54:03 +0200
Message-ID: <CACRpkdasYEFvJu0VhjGRTp2k2JupcWsrJ17g7fcrKXKphP3Zww@mail.gmail.com>
Subject: Re: [PATCH 0/2] pin controller subsystem v7
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:10 PM, Stephen Warren <swarren@nvidia.com> wrote:

> ... hence I was surprised to see that you explicitly note that mapping a
> single device to multiple controllers was disallowed.

Actually it's easy to fix, I mainly wanted to keep that until we have
a solid usecase for it, it's just a few lines of code the day we
need it.

> Then again, if this need ever does arise, we should be able to just relax
> this restriction without causing any backwards-compatibility issues, so
> I don't see a specific need to change this now; I just thought I'd mention
> it so you're aware of what I'm thinking.

It was actually on my mind, I just wanted to keep down the feature
creep to what was absolutely needed for the pin controllers we're
facing in arch/arm/* today.

Thanks!
Linus Walleij
