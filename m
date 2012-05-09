Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab2EIXCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:02:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40874 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab2EIXCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:02:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	<CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	<1336475689.1179.12.camel@mop>
	<CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
	<CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
	<1336571457.30189.29.camel@joe2Laptop>
	<CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
Date: Wed, 9 May 2012 16:02:40 -0700
X-Google-Sender-Auth: 0TeO5lnxf72QtfJVdZJm3wpe99Q
Message-ID: <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
From: Yinghai Lu <yinghai@kernel.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 7:37 AM, Kay Sievers <kay@vrfy.org> wrote:
>
>> Changing printk semantics and trying to stabilize
>> printk message content are bad ideas though.
>
> Again, nobody talks about content of here.

printk_time=1 does not work anymore with this patch on serial console.

but dmesg still have that time printout.

Yinghai
