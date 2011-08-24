Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1HXHlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:41:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56452 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1HXHlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:41:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yCAcu3uiSuDQ13ai8tmnoDkniQymp6M7DGJi84AW4mBg@mail.gmail.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4yCAcu3uiSuDQ13ai8tmnoDkniQymp6M7DGJi84AW4mBg@mail.gmail.com>
Date: Wed, 24 Aug 2011 09:41:31 +0200
Message-ID: <CACRpkdb=cM7fd033v_mztmKu_nSsoCHE_04cT8q1WfyArUZx4w@mail.gmail.com>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 8:24 AM, Barry Song <21cnbao@gmail.com> wrote:

>> +int foo_list(struct pinmux_dev *pmxdev, unsigned selector)
>
> pinctrl_dev?

Thanks Barry, fixed all instances!

Yours,
Linus Walleij
