Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1HRVdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:33:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42547 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1HRVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com>
References: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com>
Date: Thu, 18 Aug 2011 22:33:10 +0100
Message-ID: <CAPweEDwQH-pM120CQhaNy3+aQO8pUiTzFuEaPx5kbJPF6yyDLA@mail.gmail.com>
Subject: Re: ARM promising platform, needs to learn from PC.
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in http://thread.gmane.org/gmane.linux.kernel/1114495/focus=112007,
with subject "[GIT PULL] omap changes for v2.6.39 merge window" in
which the topic discussed has nothing to do with the subject (so glad
to see i'm not the only one who does that...), Thomas Gleixner said:

> I'm sure that device tree is part of the solution, but that only helps
> if we find a way to prevent duplicate drivers in the first place.

well if you apply the proposed "selfish patches are automatically
rejected in favour of collaboration patches" rule, there won't *be*
any duplicate drivers, only shared (i.e. collaborative) ones.

problem's solved, yes?

in the case of peripheral "cores" (e.g. a USB-3 Hardware Macro Block
which multiple SoC vendors license from e.g. Synopsys and lay down as
part of the CPU) i bet you that enough "Hell On Earth" for SoC vendors
whose kernel patches get rejected (because they're classified as
"selfish") would ultimately result in the actual designers of those
"cores" (e.g. Synopsys) writing the actual linux driver code
themselves.

under such circumstances, if the actual designer of the Hardware Macro
Block actually wrote the bloody linux driver, it would a) fit the
"collaborative patches rule", b) save the SoC vendors a job
reimplementing driver code c) stop the SoC vendors from submitting
duplicate drivers.

it might happen.  pigs might fly, but it might happen.

l.
