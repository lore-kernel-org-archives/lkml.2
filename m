Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2IRV3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:29:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49556 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2IRV3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:29:48 -0400
MIME-Version: 1.0
In-Reply-To: <1347958630-19672-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347958630-19672-1-git-send-email-thierry.reding@avionic-design.de>
Date: Tue, 18 Sep 2012 23:29:46 +0200
Message-ID: <CACRpkdY9XK0mN30wk93BFhZ4yZgc-4=Ym5X108OeNQYNrQogQw@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: Add Avionic Design N-bit GPIO expander support
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:57 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> This commit adds a driver for the Avionic Design N-bit GPIO expander.
> The expander provides a variable number of GPIO pins with interrupt
> support.

And you followed up on absolutely everything I commented so how
could I resist this patch ... applied with Rob's ACK!

Yours,
Linus Walleij
