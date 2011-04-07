Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1DGLyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:54:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54913 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1DGLyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:54:12 -0400
Message-ID: <4D9DA5DF.8020303@monstr.eu>
Date: Thu, 07 Apr 2011 13:54:07 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, bheglaas@google.com,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
Subject: Re: [PATCHES] Generalize PCI <-> OF node matching
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
In-Reply-To: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> This series generalize the PCI <-> OF node matching, moves it to the
> PCI core and make our archs use it. I also rip out while at it a whole
> bunch of useless stuff from microblaze PCI code which was copied from
> ppc32 and is essentially useless there (old workarounds for PowerMac
> and ancient X servers).
> 
> Compile tested on x86_64, microblaze, sparc64 and powerpc.
> 
> How do you guys want to proceed with this series ? It will quickly
> become a pre-req for other things on powerpc, so I can carry it in
> powerpc in a separate branch that I also pull into powerpc-next or
> we can have it somewhere on tip...

There are several coding style issues.
Please look at it through checkpatch.pl.

Compilation is fine for Microblaze as you surely saw.
I am not able to test it on real hw right now but I will ask for remote 
connection to the board.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
