Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1HSOTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:19:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64596 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab1HSOTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:19:45 -0400
MIME-Version: 1.0
In-Reply-To: <1313761404.18591.1.camel@vkoul-udesk3>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
	<1313499399.1603.92.camel@vkoul-udesk3>
	<CACRpkdaY_wuz+zS-iKCPT-M7EpvtxCNX+OJ6NROSaQtZ6XoNMg@mail.gmail.com>
	<1313761404.18591.1.camel@vkoul-udesk3>
Date: Fri, 19 Aug 2011 16:19:44 +0200
Message-ID: <CAKnu2Mpu2H18=xF4OwmqSgML_dDa6SE7ZqHFjLb2GL_-Wabqsw@mail.gmail.com>
Subject: Re: [PATCH] DMAEngine: Define generic transfer request api
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, sundaram@ti.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        nsekhar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/19 Koul, Vinod <vinod.koul@intel.com>:
> On Tue, 2011-08-16 at 15:06 +0200, Linus Walleij wrote:
>> On Tue, Aug 16, 2011 at 2:56 PM, Koul, Vinod <vinod.koul@intel.com> wrote:

>> I think Sundaram is in the position of doing some heavy work on
>> using one or the other of the API:s, and I think he is better
>> suited than anyone else of us to select what scheme to use,
>> in the end he's going to write the first code using the API.

> And Unfortunately TI folks don't seem to care about this discussion :(
> Haven't seen anything on this from them, or on previous RFC by Jassi

Well if there is no code usig the API then there is no rush
in merging it either I guess. Whenever someone (TI or
Samsung) cook some driver patches they can choose their
approach.

Thanks,
Linus Walleij
