Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1KHKwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:52:09 -0500
Received: from smtp3.mail.ru ([94.100.176.131]:49057 "EHLO smtp3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab1KHKwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:52:07 -0500
Date: Tue, 8 Nov 2011 18:51:52 +0800
From: Daniil Stolnikov <danila.st@mail.ru>
Reply-To: Daniil Stolnikov <danila.st@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1936723309.20111108185152@mail.ru>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        <linux-crypto@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: Add IPSec IP Range in Linux kernel
In-Reply-To: <1320733465.21617.4.camel@ppwaskie-mobl2>
References: <92909814.20111108111036@mail.ru> <1320733465.21617.4.camel@ppwaskie-mobl2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2011-11-07 at 19:10 -0800, Daniil Stolnikov wrote:
>> Hello!
>> 
>> Found that the stack IPSec in Linux does not support any IP range. Many people ask this question. The archives say strongswan said that their daemon supports a range, but the Linux IPSec stack supports only the subnets. I am writing to you to implement support for IP range in Linux. I think that a lot more people will appreciate this innovation.

> It'd be even better if you could write a patch for us to review.

> Cheers,
> -PJ

I was a little not so put it:) I'd certainly be happy and he would write a patch, but I'm afraid do not have the necessary knowledge to implement IPSec Linux. I turned to you, the developers, but rather to urge you to implement this feature using IP range. I hope very much for your help and support. This is especially beneficial for all - the Linux kernel will be more flexible and more compatible with different devices and software.

Regards
Daniil Stolnikov



