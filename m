Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0KXMNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:13:54 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:37339 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098Ab0KXMNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:13:53 -0500
Message-ID: <4CED0179.9080700@stericsson.com>
Date: Wed, 24 Nov 2010 13:13:45 +0100
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: Added new regulator_data pointer to ab8500 board
 configuration
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com> <1290536754-21775-2-git-send-email-bengt.g.jonsson@stericsson.com> <20101123183037.GA19212@rakim.wolfsonmicro.main> <4CECCBAE.6080707@stericsson.com> <20101124113655.GC24970@rakim.wolfsonmicro.main>
In-Reply-To: <20101124113655.GC24970@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-24 12:36, Mark Brown wrote:
> On Wed, Nov 24, 2010 at 09:24:14AM +0100, Bengt Jonsson wrote:
>
>> The problem I see is that ab8500-core defines the number of
>> regulators which I can see no reason for. If someone wants to add or
>> remove a regulator they have to make a change in
>> include/linux/mfd/ab8500.c as well as in the regulator files.
>
>> I will add a better description in an updated patch.
>
> Seems reasonable, though there's now an issue with the platform getting
> the size of the array wrong - might be worth adding an array size for
> the platform to initialise to catch that.
Good idea. I will try it out.
