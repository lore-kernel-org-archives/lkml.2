Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab1J1T5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 15:57:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab1J1T5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 15:57:18 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173E1B452D@HQMAIL01.nvidia.com>
References: <1319602943-17946-1-git-send-email-chanho61.park@samsung.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173E1B452D@HQMAIL01.nvidia.com>
Date: Fri, 28 Oct 2011 21:57:17 +0200
Message-ID: <CACRpkdY51N1HkUiRqoct7DiEE5Dq7b5umMxxJJLTjdC=5W6aBw@mail.gmail.com>
Subject: Re: [PATCH] drivers: pinctrl: add a pin_base for sparse gpio-ranges
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Park <chanho61.park@samsung.com>,
        Stephen Warren <swarren@nvidia.com>
Cc: "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 8:21 AM, Stephen Warren <swarren@nvidia.com> wrote:
> [Chanho]
>> -chip a: [32 .. 47]
>> -chip b: [48 .. 55]
>> -
>> -When GPIO-specific functions in the pin control subsystem are called, these
>> -ranges will be used to look up the apropriate pin controller by inspecting
>> -and matching the pin to the pin ranges across all controllers. When a
>> -... [ quit a few lines of documentation removed]
>> -(If the GPIO subsystem is ever refactored to use a local per-GPIO controller
>> -pin space, this mapping will need to be augmented accordingly.)
>
> I'm all for replacing the example here with something more complete, but
> removing all that text from the documentation doesn't seem right.

I agree. Make a real good example illustrating your setup or something
similar, so we all can understand from the documentation how to use
the different bases.

Apart from that the patch looks good.

Yours,
Linus Walleij
