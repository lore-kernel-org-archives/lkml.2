Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2INOAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:00:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59219 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2INOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:00:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120914092332.GL3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-7-git-send-email-lee.jones@linaro.org>
	<CACRpkdbs9_hLB9c7WbWeR_6+Le4Svzc9Y5wTNVebOiRDB-o33g@mail.gmail.com>
	<20120914092332.GL3374@gmail.com>
Date: Fri, 14 Sep 2012 16:00:50 +0200
Message-ID: <CACRpkdYFWAbK0x2N-bQ8_pyUEbTpWfBd9oU3quJVmyH0beNnVw@mail.gmail.com>
Subject: Re: [PATCH 06/19] ARM: ux500: Add nodes for the MSP into the HREF
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, Sep 10, 2012 at 02:53:45AM -0700, Linus Walleij wrote:
>> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > +               msp3: msp@80125000 {
>> > +                       status = "okay";
>> > +               };
>> >         };
>> >  };
>>
>> Does this really "enable" the MSPs as the title claims?
>
> Yes they do.
>
>> Aren's there any kind of bindings needed, not even a
>> register base?
>
> All that information is in the "disabled" node contained in .dtsi file.

Argh it's hard to read DT patches without parsing through all the
.dtsi:s in your head first ...

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
