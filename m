Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2KNBrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:47:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62742 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab2KNBrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:47:47 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbMPokEH80WX+M8yvAWAM-XGend3cts4K0eaj=oke8rLQ@mail.gmail.com>
References: <1352702750.15066.4.camel@phoenix>
	<CACRpkdbMPokEH80WX+M8yvAWAM-XGend3cts4K0eaj=oke8rLQ@mail.gmail.com>
Date: Wed, 14 Nov 2012 09:47:46 +0800
Message-ID: <CAN1soZy=nQfqok9pzzg9LX+wStEdJ=eCvdWPG5WA32f6bDbb1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pxa3xx: Use devm_request_and_ioremap
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 10:33 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Mon, Nov 12, 2012 at 7:45 AM, Axel Lin <axel.lin@ingics.com> wrote:
>
>> Use managed resources API to simplify the code.
>> Also ensure we do request mem_region before ioremap.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>
> Obviously correct, patch applied.
>
> Yours,
> Linus Walleij

If the patches on pinctrl-single driver are merged, it will be used as
pinctrl driver for PXA/MMP.
And this pinctrl-pxa3xx driver would be deleted. So it's not recommend
to update code on this
driver.
