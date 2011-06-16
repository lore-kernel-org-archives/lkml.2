Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab1FPPZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:25:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab1FPPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:25:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Dynamic patching in discarded sections
Date: Thu, 16 Jun 2011 17:25:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: dave.martin@linaro.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>
References: <201106081123.59414.arnd@arndb.de> <alpine.LFD.2.00.1106080946000.2142@xanadu.home> <201106161721.27330.arnd@arndb.de>
In-Reply-To: <201106161721.27330.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161725.03366.arnd@arndb.de>
X-Provags-ID: V02:K0:vYBtaCgYskTL3HL0Xrw6mN/Hqw7adaaPG6N4KruPyiA
 XN+uAmvXJKdhxIH6H3YB2qh7pSgqeTdbctUmxaT3VNuUbLAqFV
 AP3vPITkbpEqKiJrK7+UBAiLIRmHQVnpbFRquhL2CG9uuH+fHM
 wdLmEFGV6WAcxnJwt8OJFAcMLyW/UTS3/GkQKtlhf4yJs0jXrg
 ft6PBsYZsyiI4B+YbgIlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011, Arnd Bergmann wrote:
> 10000 randconfig kernel build later without that patch, I'm rather sure
> that there is only a single driver that is suffering from this. While your
> patch absolutely makes sense, a less invasive workaround would be to just
> not mark mmc_spi_remove as __devexit until Dave's patch gets in.

Scratch that. Even when Dave's patch gets into binutils, we'd still need to
make a compile time decision to figure out if the linker is new enough, so
we definitely need Nicolas' patch as well.

	Arnd
