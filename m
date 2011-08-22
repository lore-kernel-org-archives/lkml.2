Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab1HVM2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:28:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49640 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1HVM2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:28:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4z7s-ibmUuR1DA6Jps030dRrnE8M0dUWHoMhMPFtyyY_A@mail.gmail.com>
References: <1313747619-32222-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4z7s-ibmUuR1DA6Jps030dRrnE8M0dUWHoMhMPFtyyY_A@mail.gmail.com>
Date: Mon, 22 Aug 2011 14:28:12 +0200
Message-ID: <CACRpkdb4-0TfO-viUoZyW3VoLnVuo2ztHTX=8Hef3_RYWB52vg@mail.gmail.com>
Subject: Re: [PATCH 0/4 v4] pin controller subsystem v4
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 4:42 PM, Barry Song <21cnbao@gmail.com> wrote:

> it seems there is not an actual example that gpio requests pin from
> pinctrl yet. i might give one on SiRFprimaII.

No good example yet, no.

The reason is that for the U300 that I use as guinea pig, the
GPIO driver is tangled up in discussions about how to handle
the special control mechanics like requesting muxing and
biasing pins. Right now it seems easier to rewrite all that
to use the new pinctrl subsystem rather than actually trying
to work it into the GPIO subsystem first and refactor from
there, and that needs quite a bit of upfront work...

Linus Walleij
