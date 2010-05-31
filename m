Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0EaXUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:20:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57141 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab0EaXUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:20:40 -0400
MIME-Version: 1.0
From: Marcelo Jimenez <mroberto@cetuc.puc-rio.br>
Date: Mon, 31 May 2010 20:20:18 -0300
X-Google-Sender-Auth: eD4MGBLioHqh6S0O08ktpGo52zs
Message-ID: <AANLkTiny5Y6zgrpSJZypB3OoXgj1OQsXkBELB7AMrhdF@mail.gmail.com>
Subject: BSE nanoengine git tree
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been sending some patches to re-add BSA nanoengine support back
into the kernel tree since 2.6.32 IIRC. Since none of them has made
upstream, I have created a repository on github with the hope that
people interested in the support for this board can test and/or give
some feedback.

For those interested, the code has some fixed RTC logic, has support
for PCMCIA and I am working on PCI ethernet support. Currently I am
having problems trying to enable the network chip due to the lack of
documentation, so any ideas are welcome.

The URL is:

http://github.com/mrjimenez/linux-2.6

There are two branches: nanoengine and nano-pci. The branch nanoengine
is suppose to be the stable one, nano-pci is where I am doing the pci
ethernet driver work.

Any feedback is welcome.

Regards,
Marcelo.
