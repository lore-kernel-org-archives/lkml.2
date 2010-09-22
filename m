Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0IVLPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:15:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52420 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0IVLPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:15:51 -0400
Message-ID: <fdf800a16e7e44f19a684d4a4bf67288.squirrel@www.firstfloor.org>
In-Reply-To: <AANLkTimqa1++9kNcODikTVMOExhypX6+kY_m7dCKb=64@mail.gmail.com>
References: <20100922090336.GA5338@basil.fritz.box>
    <AANLkTimqa1++9kNcODikTVMOExhypX6+kY_m7dCKb=64@mail.gmail.com>
Date: Wed, 22 Sep 2010 13:15:49 +0200
Subject: Re: [PATCH] perf build fixes for opensuse 10.0
From: "Andi Kleen" <andi@firstfloor.org>
To: "John Kacur" <jkacur@redhat.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, acme@redhat.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Sep 22, 2010 at 11:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Fix the perf Makefile to compile on opensuse 10.0
>>
>> -Werror in shipping code is usually a bad idea. Remove that.
>
> Why not remove it then when you ship the code, but leave it in the kernel
> where it is useful?

What do you mean with "you ship"?

I downloaded a kernel from kernel.org, it shipped to me and didn't
build.

People can enable -Werror in their private source dirs, but
it shouldn't be in any downloadable tarball or git.

-Andi

