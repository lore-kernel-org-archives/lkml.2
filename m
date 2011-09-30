Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1I3Mwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:52:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42318 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1I3Mwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:52:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110930145042.4a7ee530848262294b297939@canb.auug.org.au>
References: <20110930145042.4a7ee530848262294b297939@canb.auug.org.au>
Date: Fri, 30 Sep 2011 14:52:28 +0200
Message-ID: <CACRpkdYkVOxHhyV1yap20YupFdw_ux39DqMK6wLb+LR+EHRusg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 6:50 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have applied the following patch for today (Linus, the
> drivers/pinctrl/pinmux.c part of this can be applied to your tree).

Thanks a lot Stephen, applied and pushed this to the pinctrl tree!

Yours,
Linus Walleij
