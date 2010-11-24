Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0KXMLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:11:41 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:34873 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862Ab0KXMLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:11:39 -0500
Message-ID: <4CED00F1.6050004@stericsson.com>
Date: Wed, 24 Nov 2010 13:11:29 +0100
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] regulators: Update of ab8500 driver
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com> <1290536754-21775-3-git-send-email-bengt.g.jonsson@stericsson.com> <20101123183833.GB19212@rakim.wolfsonmicro.main> <4CECC555.8060408@stericsson.com> <20101124104851.GA24970@rakim.wolfsonmicro.main>
In-Reply-To: <20101124104851.GA24970@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-24 11:48, Mark Brown wrote:
> On Wed, Nov 24, 2010 at 08:57:09AM +0100, Bengt Jonsson wrote:
>
>> Removing the macros is just my suggestion. The disadvantage I see
>> with macros is that I need to read both the macro and the listing to
>> see what it really does. On the other hand, macros are probably more
>
> A line of comment at the top of the macro table would probably address
> that?
I will make sure to have a comment at the top.

Still, I would like to provide a patch which removes the macros just to 
show the difference. Then you can decide to drop it or propose another 
change.

