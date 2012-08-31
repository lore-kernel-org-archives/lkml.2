Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2HaX1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:27:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41658 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HaX13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120831110818.GA5962@gmail.com>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
	<1344527828-6283-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdZa-72QogrZ-P5jbDHTTX64babZo3ydjzfgC-4LWUBfMg@mail.gmail.com>
	<20120831110818.GA5962@gmail.com>
Date: Sat, 1 Sep 2012 01:27:28 +0200
Message-ID: <CACRpkdat3zj_47r7ENz7Qv3N8cNOSKDV+k5em9DjOhkNycy9gQ@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 1/1] drivers/rtc/rtc-ab8500.c: Revoke Device
 Tree enablement
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 1:08 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, Aug 14, 2012 at 10:32:02AM +0200, Linus Walleij wrote:
>> On Thu, Aug 9, 2012 at 5:57 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > All AB8500 devices are now registered via MFD core, so Device Tree
>> > capability is no longer required for probing. Here we pull the DT
>> > match table to ensure we're no longer probed during Device Tree
>> > start-up.
>> >
>> > CC: Alessandro Zummo <a.zummo@towertech.it>
>> > CC: rtc-linux@googlegroups.com
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> I'm guessing we still need Alessandro's Ack?

Well, usually we have Andrew Morton merging patches for RTC, so
put him on CC.

If I was the MFD maintainer I'd just merge this though, it's quite
obvious.

Sam: do you agree?

Yours,
Linus Walleij
