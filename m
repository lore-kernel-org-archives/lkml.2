Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1KNRl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:41:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:64894 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab1KNRl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:41:57 -0500
Message-ID: <4EC152DC.9040208@windriver.com>
Date: Mon, 14 Nov 2011 12:41:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Axel Lin <axel.lin@gmail.com>, <linux-kernel@vger.kernel.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] mfd: include linux/module.h for ab5500-core
References: <1320635954.10415.1.camel@phoenix> <20111114001925.GF22218@sortiz-mobl>
In-Reply-To: <20111114001925.GF22218@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-13 07:19 PM, Samuel Ortiz wrote:
> Hi Axel,
> 
> On Mon, Nov 07, 2011 at 11:19:14AM +0800, Axel Lin wrote:
>> Include linux/module.h to fix below build error:
> Both patches applied, thanks a lot.

I can't tell from the above if you mean applied to an mtd specific
branch, or mainline, but just to be sure, the fixes are in mainline
for about a week now.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=3b8ce3aed986090d9249629f97c53b4dfb8c9783

Thanks,
Paul.

> 
> Cheers,
> Samuel.
> 
