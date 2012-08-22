Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab2HVOmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:42:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37250 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab2HVOmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:42:43 -0400
Date: Wed, 22 Aug 2012 10:42:40 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jon Medhurst <tixy@yxit.co.uk>, Leif Lindholm <leif.lindholm@arm.com>
Subject: Re: [PATCH 4/4] ARM: kprobes: make more tests conditional
In-Reply-To: <1345645780-2749-5-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1208221040250.1754@xanadu.home>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de> <1345645780-2749-5-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Arnd Bergmann wrote:

> The mls instruction is not available in ARMv6K or below, so we
> should make the test conditional on at least ARMv7. ldrex/strex
> are available in ARMv6K or ARMv7, which we can test by checking
> the CONFIG_CPU_32v6K symbol. Just testing for ARMv6 is not enough.

The ldrex/strex instructions are available on ARMv6.  It's only the d 
variants (strexd/ldrexd) which are only available from ARMv6k.


Nicolas
