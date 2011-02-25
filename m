Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab1BYQg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:36:29 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:58984 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab1BYQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:36:28 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: bug in 2.6.32-5-amd64 : aufs/memory management related?
To: "Emmanuel V." <antro5@free.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4D67CAE4.2060909@free.fr>
References: <4D67CAE4.2060909@free.fr>
Date: Sat, 26 Feb 2011 01:36:22 +0900
Message-ID: <9665.1298651782@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"Emmanuel V.":
> $ cat /proc/version
> Linux version 2.6.32-5-amd64 (Debian 2.6.32-30) (ben@decadent.org.uk) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Wed Jan 12 03:40:32 UTC 2011
>
> $ dmesg
>
> [...]
> [10688.154693] ------------[ cut here ]------------
> [10688.154741] kernel BUG at /build/buildd-linux-2.6_2.6.32-30-amd64-d4MbNM/linux-2.6-2.6.32/debian/build/source_amd64_none/mm/mmap.c:873!
	:::

According to http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=607879,
Debian people already fixed this problem (although I am afraid they are
still using an obsoleted version of aufs).

And this is debian specific problem and aufs is not in mainline. I don't
think this ML is appropriate for such problem.


J. R. Okajima
