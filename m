Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1LWJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:16:59 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58491 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1LWJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:16:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh0hwNZCL0hEAb-ny5-KrB6N1uZjg9Wngzv_5XBMRCHqcxd7A@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<1162.1324625149@jrobl>
	<CAOh0hwNZCL0hEAb-ny5-KrB6N1uZjg9Wngzv_5XBMRCHqcxd7A@mail.gmail.com>
Date: Fri, 23 Dec 2011 10:16:56 +0100
Message-ID: <CAFLxGvxEn6gVnHM6kWdFjpv2RBDUnjSGCjuNF3Fz9ihhFNLmdg@mail.gmail.com>
Subject: Re: Intercepting system calls
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:08 AM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
> Ok I have seen details of KPROBES, I think it will suit to my
> requirements, I just wanted to know a few things,
> Can I use probes to prevent unlink of certain files? Also is
> CONFIG_KPROBES set to "y" on linux kernels available with distros like
> ubuntu?

Kprobes allow you to instrument the kernel.
AFAIK it enabled by most distros.

-- 
Thanks,
//richard
