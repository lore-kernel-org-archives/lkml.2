Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1HQIxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 04:53:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37065 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1HQIxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 04:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3883899A6@AUSP01VMBX24.collaborationhost.net>
References: <1312978655-18405-1-git-send-email-linus.walleij@stericsson.com>
	<ADE657CA350FB648AAC2C43247A983F001F38838966E@AUSP01VMBX24.collaborationhost.net>
	<CACRpkdabHj_C7wgGfu3g6LSsa2iMZS0h279wf6McOxfge9Gm_w@mail.gmail.com>
	<ADE657CA350FB648AAC2C43247A983F001F388389983@AUSP01VMBX24.collaborationhost.net>
	<ADE657CA350FB648AAC2C43247A983F001F3883899A6@AUSP01VMBX24.collaborationhost.net>
Date: Wed, 17 Aug 2011 10:53:15 +0200
Message-ID: <CACRpkdYDsBRew0WpR1655k4+7BpUomOCEVyrH-Or88WJ4MjzJg@mail.gmail.com>
Subject: Re: [PATCH 10/19] mach-ep93xx: break out GPIO driver specifics
From: Linus Walleij <linus.walleij@linaro.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 7:48 PM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> On Thursday, August 11, 2011 10:16 AM, H Hartley Sweeten wrote:

>> The other solution is to hook up the gpiolib to_irq callback in
>> gpio-ep93xx and do:
>>
>> #define gpio_to_irq   __gpio_to_irq
>>
>> Maybe this is a better option?
>
> BTW, I have a patch for this if you want.

Thanks! I'm fixing up this patchset so will include this one
and rebase on top of it.

Yours,
Linus Walleij
