Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0KTLeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 06:34:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0KTLeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 06:34:11 -0500
Message-ID: <4CE7B1CF.8060300@redhat.com>
Date: Sat, 20 Nov 2010 13:32:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Marcus Meissner <meissner@suse.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, akpm@osdl.org,
        hpa@zytor.com, mingo@elte.hu, w@1wt.eu, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101116104600.GA24015@suse.de> <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
In-Reply-To: <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 07:40 AM, Kyle Moffett wrote:
>    (1) For 99%+ of all the computers out there you can get a 90%+
> accurate guess for what kernel is running by looking at the version of
> libc installed on the system.  All you have to do for those computers
> is download a bunch of distro kernels and look at the libc packages
> and build a table of "libc6-SOMEVERSION =>  0xADDRESS", etc.  Because
> of how all the vendors backport and track versions, "SOMEVERSION"
> usually includes something wonderfully helpful like "el5" or "squeeze"
> or whatever.  This does *nothing* for those users, and it's not clear
> that it ever *could*.

Isn't the kernel relocatable these days?  We can randomize the kernel 
load address at boot time and make this information useless.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

