Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1LWJ0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:26:20 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45515 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1LWJ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:26:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh0hwPDAa0_0ESh8RNRuTTk8uMbdpZ=zZOfJ1-UfMQkVViMeg@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<1162.1324625149@jrobl>
	<CAOh0hwNZCL0hEAb-ny5-KrB6N1uZjg9Wngzv_5XBMRCHqcxd7A@mail.gmail.com>
	<CAFLxGvxEn6gVnHM6kWdFjpv2RBDUnjSGCjuNF3Fz9ihhFNLmdg@mail.gmail.com>
	<CAOh0hwPDAa0_0ESh8RNRuTTk8uMbdpZ=zZOfJ1-UfMQkVViMeg@mail.gmail.com>
Date: Fri, 23 Dec 2011 10:26:15 +0100
Message-ID: <CAFLxGvzGWddcSMK58-+OozyQHDNFd+z0-XSNiC47r+VpmXqnyg@mail.gmail.com>
Subject: Re: Intercepting system calls
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:22 AM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
> Hello Richard
>
> On Fri, Dec 23, 2011 at 2:46 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Fri, Dec 23, 2011 at 10:08 AM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
>>> Ok I have seen details of KPROBES, I think it will suit to my
>>> requirements, I just wanted to know a few things,
>>> Can I use probes to prevent unlink of certain files? Also is
>>> CONFIG_KPROBES set to "y" on linux kernels available with distros like
>>> ubuntu?
>>
>> Kprobes allow you to instrument the kernel.
>> AFAIK it enabled by most distros.
> Can I use probes to return immediately ie. without execution of
> original system call. For example I put a entry probe on unlink and
> then on the probe return value unlink code is executed or not. Is that
> possible ?
> Also can I call a userspace function from kernel code? Would that be insecure ?

Using Kprobes you can do nearly anything.
But I would be surprised if you find a acceptable and sane solution.

-- 
Thanks,
//richard
