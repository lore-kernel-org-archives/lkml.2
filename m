Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2DPPwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:52:39 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27631 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2DPPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:52:38 -0400
Message-ID: <4F8C4033.2050600@atmel.com>
Date: Mon, 16 Apr 2012 17:52:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: olof@lixom.net, ludovic.desroches@atmel.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/12] at91: 3.4-rc3 fixes
References: <cover.1334567594.git.nicolas.ferre@atmel.com> <201204161540.08389.arnd@arndb.de>
In-Reply-To: <201204161540.08389.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 05:40 PM, Arnd Bergmann :
> On Monday 16 April 2012, Nicolas Ferre wrote:
>> Here is another fixes series for AT91 that will go on top of 3.4-rc3.
>> We experienced some issues while compiling some drivers as modules: Joachim has
>> corrected several of them. We may reduce this number of exported values by
>> reworking some drivers, in the future.
>> Some drivers are also modified here, I would like to keep them in the series
>> as the modifications are really related with our recent move to irqdomains or
>> simply related with compiler annotations.
> 
> I looked at all the patches, they look good to me, but patch 9 does not
> seem to be an actual bug-fix rather than a cleanup, so you might want
> to put that into a different series.

Yes, it is dead code that can go in a cleanup series for 3.5...

I can remove it and build a "pull request" tomorrow.

Thanks for this review Arnd.

Cheers,
-- 
Nicolas Ferre
