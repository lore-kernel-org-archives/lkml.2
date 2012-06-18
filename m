Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2FRLh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:37:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64578 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2FRLh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:37:57 -0400
Message-ID: <4FDF1311.1050207@linaro.org>
Date: Mon, 18 Jun 2012 12:37:53 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: ux500: Add i2c configurations to the Device
 Tree for DB8500 based devices
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com> <4FD8BAE4.4050606@linaro.org> <CACRpkda2pH1by2hajpP20CJgdg+mWFF=QaGbeNdY=c8iOVtLUQ@mail.gmail.com>
In-Reply-To: <CACRpkda2pH1by2hajpP20CJgdg+mWFF=QaGbeNdY=c8iOVtLUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/12 12:29, Linus Walleij wrote:
> On Wed, Jun 13, 2012 at 6:08 PM, Lee Jones<lee.jones@linaro.org>  wrote:
>
>> +                       clock-frequency =<100000>;
>> +                       stericsson,slsu =<0xe>;
>> +                       stericsson,tft =<1>;
>> +                       stericsson,rft =<8>;
>> +                       stericsson,timeout =<200>;
>> +                       stericsson,i2c_freq_mode_fast;
>
> In the context of my patch to the board file, we conclude that the
> clock-frequency should be set to 400000 instead.

Right, I have already changed that in my patch-set.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
