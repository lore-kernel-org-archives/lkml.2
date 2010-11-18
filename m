Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231Ab0KRU0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:26:06 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:58670 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186Ab0KRU0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:26:04 -0500
Message-ID: <4CE58BBD.8010706@cs.columbia.edu>
Date: Thu, 18 Nov 2010 15:25:33 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Tejun Heo <tj@kernel.org>, Gene Cooperman <gene@ccs.neu.edu>,
        Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <20101106053204.GB12449@count0.beaverton.ibm.com> <20101106204008.GA31077@sundance.ccs.neu.edu> <4CD5D99A.8000402@cs.columbia.edu> <20101107184927.GF31077@sundance.ccs.neu.edu> <4CD72150.9070705@cs.columbia.edu> <4CE3C334.9080401@kernel.org> <20101117221713.GA27736@count0.beaverton.ibm.com>
In-Reply-To: <20101117221713.GA27736@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/17/2010 05:17 PM, Matt Helsley wrote:
> On Wed, Nov 17, 2010 at 12:57:40PM +0100, Tejun Heo wrote:
>> Hello, Oren.
>>
>> On 11/07/2010 10:59 PM, Oren Laadan wrote:

<snip>

>>> Or we could use linux-cr for that: do the c/r in the kernel,
>>> keep the know-how in the kernel, expose (and commit to) a
>>> per-kernel-version ABI (not vow to keep countless new individual
> 
> Oren, that statement might be read to imply that it's based on
> something as useless as kernel version numbers. Arnd has pointed out in the
> past how unsuitable that is and I tend to agree. There are at least two
> possible things we can relate it to: the SHA of the compiled kernel tree
> (which doesn't quite work because it assumes everybody uses git trees :( ),
> or perhaps the SHA/hash of the cpp-processed checkpoint_hdr.h. We could
> also stuff that header into the kernel (much like kconfigs are output from
> /proc) for programs that want the kernel to describe the ABI to them.

BTW, it's the same for userspace c/r: for the same set of features,
the format (ABI) remains unchanged. Adding features breaks this and
a new version is necessary, and conversion from old to new will be
needed.

Moreover, supporting a new feature in userspace means adding the
proper API/ABI in the kernel, including refactoring etc, which is
even harder than adding the support for it in linux-cr.

Oren.
