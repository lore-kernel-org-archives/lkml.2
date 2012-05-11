Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2EKIdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:33:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64274 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab2EKIdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <4FAAD95D.9010108@wwwdotorg.org>
References: <1336470347-23886-1-git-send-email-linus.walleij@stericsson.com>
	<4FAAD95D.9010108@wwwdotorg.org>
Date: Fri, 11 May 2012 10:33:08 +0200
Message-ID: <CACRpkdYRv5w=P4zTLZiG69rMN5Rt-yah4EdgWfg03oD7Tcvzqw@mail.gmail.com>
Subject: Re: [PATCH 12/12] ARM: ux500: switch MSP to using pinctrl for pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 10:53 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/08/2012 03:45 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> The MSP platform data callbacks use the old custom callbacks to
>> set the state of the pins, switch over to using pinctrl.
>
> Aside from the comments I've already made, I guess you can consider the
> whole series:
>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Thanks Stephen! Pushing this through ARM SoC.

Yours,
Linus Walleij
