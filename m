Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2KSL6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:58:15 -0500
Received: from void.printf.net ([89.145.121.20]:55990 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2KSL6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:58:13 -0500
From: Chris Ball <cjb@laptop.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Standardise capability type
References: <1352896551-17948-1-git-send-email-lee.jones@linaro.org>
	<87haon99py.fsf@octavius.laptop.org> <20121119092725.GA553@gmail.com>
Date: Mon, 19 Nov 2012 06:58:03 -0500
In-Reply-To: <20121119092725.GA553@gmail.com> (Lee Jones's message of "Mon, 19
	Nov 2012 09:27:25 +0000")
Message-ID: <87mwydhkj8.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 19 2012, Lee Jones wrote:
>> > There are discrepancies with regards to how MMC capabilities
>> > are carried throughout the subsystem. Let's standardise them
>> > to elevate any confusion.
>> 
>> I think you meant "eliminate" here.  :)  Thanks,
>
> No, I meant alleviate. :)
>
> Do you want me to re-submit, or have you fixed up?

I already pushed with a change to "eliminate" -- I'll leave it like
that if that's okay.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
