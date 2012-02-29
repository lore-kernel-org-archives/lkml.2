Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2B2I4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:56:16 -0500
Received: from mail.southpole.se ([193.12.106.18]:45919 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2B2I4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:56:14 -0500
Message-ID: <1330505774.2964.31.camel@crucifix>
Subject: Re: [PATCH 2/2] OpenRISC: IRQ: Include module.h
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: arnd@arndb.de, linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 09:56:14 +0100
In-Reply-To: <4F4DE438.6050707@nod.at>
References: <1330476393-14264-1-git-send-email-richard@nod.at>
	  <1330476393-14264-2-git-send-email-richard@nod.at>
	 <1330501749.2964.4.camel@crucifix> <4F4DE438.6050707@nod.at>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 05773-08444
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2012-02-29 at 09:39 +0100, Richard Weinberger wrote:
> Am 29.02.2012 08:49, schrieb Jonas Bonn:
> You are right. export.h is better.
> I forgot commit f501693 (module.h: split out the EXPORT_SYMBOL into export.h).
> 
> > Thanks for helping out with build-testing the OpenRISC arch... much
> > appreciated.
> 
> I'm doing more than build-testing.
> Yesterday my FPGA board booted the very first time Linux on OpenRISC. :-)
> 
> Thanks,
> //richard
> 

Ah, awesome!  Glad to hear that.

I'll just let you in on the little catch with the upstream OpenRISC
kernel, then:  it drops support for deprecated syscalls; unfortunately,
there is no libc that supports that yet.

For that reason, the kernel at git://openrisc.net/jonas/linux is still
the one that is most usable... it's carrying a patch to reenable those
syscalls so that uClibc works.

I've got a patch series that attempts to fix that, but upstream uClibc
didn't seem particularly enamored by the idea of adding more code to
libc so that Linux can get smaller... and that's kind of where we got
stuck.

Probably best to drop linux-kernel from this conversation at this point,
but feel free to continue it at linux@lists.openrisc.net

/Jonas

