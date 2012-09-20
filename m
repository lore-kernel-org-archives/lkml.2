Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2ITGvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:51:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51228 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2ITGvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120914084729.GG3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-12-git-send-email-lee.jones@linaro.org>
	<CACRpkdY+t9MwWewtZzpD7i4eeTxVHNk+NxSZ1E=T-k4a0mveHg@mail.gmail.com>
	<20120914084729.GG3374@gmail.com>
Date: Thu, 20 Sep 2012 08:51:37 +0200
Message-ID: <CACRpkdakOF6gmckrn0apynGippb2Z-oa82eYtv6tBoKH8pKrYA@mail.gmail.com>
Subject: Re: [PATCH 11/19] ARM: ux500: Add all known I2C sub-device nodes to
 the HREF DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:47 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, Sep 10, 2012 at 04:34:15AM -0700, Linus Walleij wrote:
>> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > Here we add the skeleton nodes for each of the known I2C sub-devices
>> > currently registered on ST-Ericsson's HREF Development Platform. We
>> > will fill these nodes in turn as the drivers are enabled for Device
>> > Tree.
>> >
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> Can't we have it the other way around (discussing patch ordering
>> with Arnd simultaneously), so you first add the DT support to the
>> subdevices, then add the more complete nodes to the device tree?
>>
>> And if you put in a device tree like this, will these devices
>> not collide with the ones that are currently supplied from
>> the boardfiles? I'm a bit confused here, maybe I'm not smart
>> enough to understand this...
>
> Okay, I've reordered the patch-set to address these possible issues.

OK sorry for delay, I've been patch-swamped...

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
