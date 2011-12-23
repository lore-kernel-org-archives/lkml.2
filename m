Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1LWJJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:09:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49775 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab1LWJJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:09:31 -0500
MIME-Version: 1.0
In-Reply-To: <1162.1324625149@jrobl>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <1162.1324625149@jrobl>
From: Gaurav Saxena <grvsaxena419@gmail.com>
Date: Fri, 23 Dec 2011 14:38:59 +0530
Message-ID: <CAOh0hwNZCL0hEAb-ny5-KrB6N1uZjg9Wngzv_5XBMRCHqcxd7A@mail.gmail.com>
Subject: Re: Intercepting system calls
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello  J. R. Okajima

On Fri, Dec 23, 2011 at 12:55 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Hello Gaurav,
>
> Gaurav Saxena:
>> I am writing an application for which I need to intercept some
>> filesystem system calls eg. unlink. I need unlink to call my code
>        :::
>
> For kernel space, CONFIG_KPROBES may help you.
> See Documentation/kprobes.txt in detail.
Ok I have seen details of KPROBES, I think it will suit to my
requirements, I just wanted to know a few things,
Can I use probes to prevent unlink of certain files? Also is
CONFIG_KPROBES set to "y" on linux kernels available with distros like
ubuntu?
>
> For user space, $LD_PRELOAD may help you.
> You will need to develop your shared object library which contains
> your_unlink() and replaces the original unlink().
> See ld.so(8) manual page.
>
>
> J. R. Okajima



-- 
Thanks and Regards ,
Gaurav
