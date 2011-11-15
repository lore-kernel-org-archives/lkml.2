Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1KOAjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:39:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65241 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1KOAjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:39:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111114.184240.1832866874941847383.davem@davemloft.net>
References: <1321312921-7748-1-git-send-email-grundler@chromium.org>
	<1321312921-7748-5-git-send-email-grundler@chromium.org>
	<20111114.184240.1832866874941847383.davem@davemloft.net>
Date: Mon, 14 Nov 2011 16:39:13 -0800
X-Google-Sender-Auth: boDy07ThCra58TOqkeLhTxnVjcM
Message-ID: <CANEJEGstEcWx=WD5ZfBrErOpzi+PTQys1hF0scPdVADwQFY+Yw@mail.gmail.com>
Subject: Re: [PATCH 5/5] net-next:asix: update VERSION and white space changes
From: Grant Grundler <grundler@chromium.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 3:42 PM, David Miller <davem@davemloft.net> wrote:
> From: Grant Grundler <grundler@chromium.org>
> Date: Mon, 14 Nov 2011 15:22:01 -0800
>
>> No functional changes. Three things targeted:
>> o update VERSION to reflect previous changes.
>> o fix up white space/formatting of some lines
>> o define 150 to be AX_SWRESET_MDELAY (self documenting code)
>>
>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>
> Why have such a wonderful set of real bug fixes that I can apply right
> now and send off to Linus's tree, only to sabotage it with whitespace
> changes at the end which are no appropriate?
>
> Please, just submit this without the whitespace and other cleanup
> stuff.  Restrict it to real bug fixes, and I'll push it around.

No Problem! :)

I wasn't expecting this to go to linus immediately but it makes that it should.

> The whitespace and other bits can be submitted for net-next afterwards.

Will do.

cheers,
grant
