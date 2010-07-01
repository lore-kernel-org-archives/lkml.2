Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861Ab0GAWjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:39:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404Ab0GAWjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:39:15 -0400
Date: Thu, 1 Jul 2010 15:37:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Claudio Scordino <claudio@evidence.eu.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Howard Chu <hyc@symas.com>,
       Peter Ma <pma@mediamatech.com>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Alan Cox <alan@linux.intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       Bernhard Roth <br@pwrnet.de>, Ryan Mallon <ryan@bluewatersys.com>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Rick Bronson <rick@efn.org>, Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] serial: fix rs485 for atmel_serial on avr32
Message-Id: <20100701153751.ef384583.akpm@linux-foundation.org>
In-Reply-To: <201006291935.40229.PeterHuewe@gmx.de>
References: <201006291935.40229.PeterHuewe@gmx.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 19:35:39 +0200
Peter H__we <PeterHuewe@gmx.de> wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch fixes a build failure [1-4] in the atmel_serial code introduced by
> patch the patch ARM: 6092/1: atmel_serial: support for RS485
> communications (e8faff7330a3501eafc9bfe5f4f15af444be29f5)
> 
> The build failure was caused by missing struct field and missing defines
> for the avr32 board - the patch fixes this.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> Despite so many reviewers of the original patch no one seemed to 
> notice this issue :/
> 
> KernelVersion: linux-next-20100629
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2575242/ - first failure
> in linux-next, may 11th
> [2] http://kisskb.ellerman.id.au/kisskb/buildresult/2816418/ - still
> exists as of today
> [3] http://kisskb.ellerman.id.au/kisskb/buildresult/2617511/ - first
> failure in Linus' tree - May 20th - did really no one notice this?!
> [4] http://kisskb.ellerman.id.au/kisskb/buildresult/2813956/ - still
> exists in Linus' tree as of today
> 
>  arch/avr32/include/asm/ioctls.h             |    3 +++
>  arch/avr32/mach-at32ap/include/mach/board.h |    2 ++
>  drivers/serial/atmel_serial.c               |    1 +
>  3 files changed, 6 insertions(+), 0 deletions(-)

ooookay.  Thanks, I'll take it if nobody else will ;)

