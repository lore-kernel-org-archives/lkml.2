Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2HRWVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 18:21:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52939 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2HRWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 18:21:13 -0400
MIME-Version: 1.0
In-Reply-To: <502C8247.7070209@samsung.com>
References: <502C8247.7070209@samsung.com>
Date: Sun, 19 Aug 2012 00:21:12 +0200
Message-ID: <CACRpkdZjssRDyE6FRsY6O6_30XBNRk4_TTS7B1=7DcmXvo8Hhw@mail.gmail.com>
Subject: Re: [PATCH v4] mmc: card: Skip secure option for MoviNAND.
From: Linus Walleij <linus.walleij@linaro.org>
To: IAN CHEN <ian.cy.chen@samsung.com>
Cc: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 7:16 AM, IAN CHEN <ian.cy.chen@samsung.com> wrote:

> For several MoviNAND, there are some known issue with secure option.
> For these specific MoviNAND device, we skip secure option.
>
> You could refer this discussion in XDA developers.
> http://forum.xda-developers.com/showthread.php?t=1644364
> https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184813224730/posts/21pTYfTsCkB
>
> Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>

Looking good!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
