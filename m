Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab2DJSbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:31:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36042 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab2DJSbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:31:24 -0400
MIME-Version: 1.0
In-Reply-To: <4F8457F9.7090309@wwwdotorg.org>
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
	<1333553270-9040-5-git-send-email-swarren@wwwdotorg.org>
	<CACRpkdZzET9OKC8xoXV_4OBAd9-EuhSh-OfG=es56bKidCoe9Q@mail.gmail.com>
	<4F8457F9.7090309@wwwdotorg.org>
Date: Tue, 10 Apr 2012 20:31:23 +0200
Message-ID: <CACRpkdb=8ydKuX52cen8Y_iBzV+RwD61NCPrjQFXNgoO-=bc9Q@mail.gmail.com>
Subject: Re: [PATCH V4 REPOST 5/5] pinctrl: tegra: Add complete device tree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 5:55 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Is your pinctrl for-next branch considered "stable" (i.e. it won't ever
> be rebased) at least up to commit a57be23 "pinctrl: tegra: Add complete
> device tree support"?

Not quite yet, because I would expect the occasional -rc fix for
-rc3 or so.

> If so, I'll use it as a base for the Tegra GPIO and pinmux rework branch.

Soon-ish that'd work...

Yours,
Linus Walleij
