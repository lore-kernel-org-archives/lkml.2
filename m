Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2KWQra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:47:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2KWQr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 11:47:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC PATCH v1 24/40] metag: DMA
Date: Fri, 23 Nov 2012 16:47:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1351700061-7203-1-git-send-email-james.hogan@imgtec.com> <50AF9C06.3010705@imgtec.com> <50AFA24D.4030501@imgtec.com>
In-Reply-To: <50AFA24D.4030501@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211231647.27260.arnd@arndb.de>
X-Provags-ID: V02:K0:MQJA6OfkA6LR7NMQqt8/rK7jVQVEpuHu4P4Uks/3Zf4
 T2SS1HNQYOYjvYS/+gSArkGjNIonw8quakObK9bnRsnjcN9pLq
 0D0Zx+c+EkAnJER0l4J4C8XU59JKUKODvmC8B3ME0OMrWmHFj0
 xtmP05jjHiblW9jeWssvKgi14f9dKBM3bU1LpGJr9lD/7e4zEo
 JlKO/GRqESkMXuTWkmbuK915bhsFqhaiIRWy902G7RA+1eDDZZ
 79loxuUMvNvd+LU+iF3MRav+lnl71r0gcPCquU3Uqfhqr+SlX2
 cn3UonOzyt3TSz2wc+uzFBezJlnBDnkPJqOS4Zh5MJSO5ZUJj1
 GwLhI91Bvgf9Ba40lF1c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 November 2012, James Hogan wrote:
> Subject: [PATCH 1/1] asm-generic/io.h: check CONFIG_VIRT_TO_BUS
> 
> Make asm-generic/io.h check CONFIG_VIRT_TO_BUS before defining
> virt_to_bus() and bus_to_virt(), otherwise it's easy to accidentally
> have a silently failing incorrect direct mapped definition rather then
> no definition at all.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Good catch!

Acked-by: Arnd Bergmann <arnd@arndb.de>
