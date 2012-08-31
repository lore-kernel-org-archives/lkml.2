Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2HaX2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:28:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43372 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HaX2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:28:35 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdat3zj_47r7ENz7Qv3N8cNOSKDV+k5em9DjOhkNycy9gQ@mail.gmail.com>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
	<1344527828-6283-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdZa-72QogrZ-P5jbDHTTX64babZo3ydjzfgC-4LWUBfMg@mail.gmail.com>
	<20120831110818.GA5962@gmail.com>
	<CACRpkdat3zj_47r7ENz7Qv3N8cNOSKDV+k5em9DjOhkNycy9gQ@mail.gmail.com>
Date: Sat, 1 Sep 2012 01:28:34 +0200
Message-ID: <CACRpkdbXwLXoWL+PS-wJ9cbztC-jWhyc=vr+98ffg70f6coaiQ@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 1/1] drivers/rtc/rtc-ab8500.c: Revoke Device
 Tree enablement
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 1, 2012 at 1:27 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Aug 31, 2012 at 1:08 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> On Tue, Aug 14, 2012 at 10:32:02AM +0200, Linus Walleij wrote:
>>> On Thu, Aug 9, 2012 at 5:57 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>>
>>> > All AB8500 devices are now registered via MFD core, so Device Tree
>>> > capability is no longer required for probing. Here we pull the DT
>>> > match table to ensure we're no longer probed during Device Tree
>>> > start-up.
>>> >
>>> > CC: Alessandro Zummo <a.zummo@towertech.it>
>>> > CC: rtc-linux@googlegroups.com
>>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>
>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> I'm guessing we still need Alessandro's Ack?
>
> Well, usually we have Andrew Morton merging patches for RTC, so
> put him on CC.
>
> If I was the MFD maintainer I'd just merge this though, it's quite
> obvious.
>
> Sam: do you agree?

Or wait, Sam was not on the To: line...

Yours,
Linus Walleij
