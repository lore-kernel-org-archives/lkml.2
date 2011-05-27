Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1E0Phz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:37:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45950 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab1E0Phx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:37:53 -0400
Message-ID: <4DDFC4F0.4070204@ru.mvista.com>
Date: Fri, 27 May 2011 19:36:16 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Pitre <nico@fluxnic.net>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH][Trivial] ARM: remove duplicate include from	arch/arm/mach-dove/common.c
References: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jesper Juhl wrote:

> Remove duplicate linux/serial_8250.h include from 
> arch/arm/mach-dove/common.c that was introduced by commit 
> 5c60255149eece2a36ec9f5c99817b85f96fe8ec .

   Please also specify that commit's summary -- for the human readers.

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

WBR, Sergei
