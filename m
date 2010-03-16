Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937612Ab0CPJvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:51:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43378
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932488Ab0CPJvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:51:13 -0400
Date: Tue, 16 Mar 2010 02:51:34 -0700 (PDT)
Message-Id: <20100316.025134.196872789.davem@davemloft.net>
To: mingo@elte.hu
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       efault@gmx.de, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH 2/2] perf top: Properly notify the user that vmlinux is
 missing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100316094611.GG7961@elte.hu>
References: <20100315192125.GL6965@ghostprotocols.net>
	<20100315.122605.124976085.davem@davemloft.net>
	<20100316094611.GG7961@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Mar 2010 10:46:11 +0100

> i'd really like that to happen - i.e. if we had the kernel (and modules) image 
> exposed as a (almost-)standard ELF object via /sys or so.
> 
> We already have some aspects of that, via /sys/kernel/notes, but it should be 
> done for real. That would also make build-id support less of a hack.
> 
> ( I'd not include CFI debuginfo in there though - that would be way too large.
>   More compressed debuginfo could be included perhaps. )

That's interesting and useful, but wouldn't help my case as the images
I'm usually booting are completely stripped.

That's why I end up with "[kernel.kallsyms]" for kernel profiling :-)
