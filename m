Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1KHOYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:24:23 -0500
Received: from smtp24.mail.ru ([94.100.176.177]:49047 "EHLO smtp24.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab1KHOYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:24:20 -0500
Date: Tue, 8 Nov 2011 22:24:11 +0800
From: Daniil Stolnikov <danila.st@mail.ru>
Reply-To: Daniil Stolnikov <danila.st@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1247539123.20111108222411@mail.ru>
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        <linux-crypto@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: Add IPSec IP Range in Linux kernel
In-Reply-To: <CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com>
References: <92909814.20111108111036@mail.ru> <1320733465.21617.4.camel@ppwaskie-mobl2> <CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Nov 8, 2011 at 8:24 AM, Peter P Waskiewicz Jr
> <peter.p.waskiewicz.jr@intel.com> wrote:
>> On Mon, 2011-11-07 at 19:10 -0800, Daniil Stolnikov wrote:
>>> Hello!
>>>
>>> Found that the stack IPSec in Linux does not support any IP range. Many people ask this question. The archives say strongswan said that their daemon supports a range, but the Linux IPSec stack supports only the subnets. I am writing to you to implement support for IP range in Linux. I think that a lot more people will appreciate this innovation.
>>
>> It'd be even better if you could write a patch for us to review.

> oh, come on!
> changing addr_match() is trivial for ipv4 and easy for ipv6. :-)


Is not entirely clear how this function works. It seems that it works again with the subnet bits and comparing the length of the prefix networks.

Probably you mean that you need to add back the comparison ranges? If so, what if we use zywall we do not know the format of the range.
Well, as I said, I badly oriented in the kernel code. I can tell kettle. A change in the function code certainly entail a change in at least the data types passed to the function.

