Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2KQSB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 13:01:29 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:36484 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2KQSB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 13:01:28 -0500
Date: Sat, 17 Nov 2012 19:01:21 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Joachim Eastwood <manabian@gmail.com>
Cc: dhowells@redhat.com, hskinnemoen@gmail.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org
Subject: Re: [PATCH] AVR32: switch to generic param.h
Message-ID: <20121117180121.GA16905@samfundet.no>
References: <1353164658-14509-1-git-send-email-manabian@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353164658-14509-1-git-send-email-manabian@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sat 17 Nov 2012 16:04:18 +0100 or thereabout, Joachim Eastwood wrote:
> Since commit 83b9d3a0 (UAPI: (Scripted) Disintegrate arch/avr32/include/asm)
> building AVR32 spews out tons warnings like this:
>  In file included from include/linux/sched.h:11,
>                   from init/do_mounts_initrd.c:17:
>  /linux-2.6/arch/avr32/include/asm/param.h:6:1: warning: "HZ" redefined
> 
> Everything we need from param.h on AVR32 is already in
> asm-generic so let's use that.
> 
> Signed-off-by: Joachim Eastwood <manabian@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp diff>

-- 
HcE
