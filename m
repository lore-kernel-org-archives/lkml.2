Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0INFtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:49:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41778 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab0INFtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:49:47 -0400
Message-ID: <4C8F0CF8.1050309@cs.helsinki.fi>
Date: Tue, 14 Sep 2010 08:49:44 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>,
        linux kernel <linux-kernel@vger.kernel.org>, tj@linux.com,
        "=?ISO-8859-1?Q?Jonas_=C5berg?=" <jonas.aberg@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regression on UP ARM from commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
References: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com> <alpine.DEB.2.00.1009130855430.26275@router.home>
In-Reply-To: <alpine.DEB.2.00.1009130855430.26275@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/10 4:58 PM, Christoph Lameter wrote:
> On Sun, 12 Sep 2010, Linus Walleij wrote:
>
>> commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
>> "slub: Remove static kmem_cache_cpu array for boot"
>> made my ARM 926 UP system hang at boot, if I revert this (have
>> to back out a lot of SLUB patches for that) it comes back up. (Same if I
>> switch to SLAB.)
>>
>> Any hints on how I can get patch around this in a nice way?
>
> This is UP right? Any more details on this one? Does ARM have
> earlyprintk?
>
> Tejun also has some patches that make the percpu allocator work on UP so
> that we do not need the hack (you must have the hack which is commit
> c23e5ad729ac43f5e2fbc080f94cf61f07b4d45f as well to make UP work right!).
>
> I am not sure if they are already in -next though.

Yes, they should be in linux-next. I haven't pulled the changes to 
slab.git, though. Linus, do things work in linux-next if you revert 
commit 5249d039500f05a5ab379286b1d23ab9b04d3f2c ("Slub: UP bandaid")?

			Pekka
