Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0IPTtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:49:19 -0400
Received: from xenotime.net ([72.52.115.56]:46340 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752517Ab0IPTtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:49:18 -0400
Message-ID: <57832.148.87.67.141.1284666548.squirrel@www.xenotime.net>
In-Reply-To: <AANLkTi=_oOViKt2=1ZHDQgRRLiYDBwOp=UY=XdGrtZsH@mail.gmail.com>
References: <AANLkTi=_oOViKt2=1ZHDQgRRLiYDBwOp=UY=XdGrtZsH@mail.gmail.com>
Date: Thu, 16 Sep 2010 12:49:08 -0700 (PDT)
Subject: Re: tracing lost time in early boot
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Martin Pirker" <lkml.collector@gmail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, August 1, 2010 7:28 am, Martin Pirker wrote:
> Hi...
>
>
> My machine "loses" quite some time at boot:
> ...
> [    0.006881] ACPI: Core revision 20100428
> [   45.284319] DMAR: Host address width 36
> ...
>
>
> I digged through Documentation and tried some boot options but so far
> failed, so could someone please point me to the right way to debug where
> exactly the kernel is spending this time during boot?

need more info.

What kind of machine is it?

Please post your kernel .config file and boot options used.

-- 
~Randy

