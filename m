Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0F3Q5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:57:45 -0400
Received: from relais.videotron.ca ([24.201.245.36]:40114 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab0F3Q5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:57:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 30 Jun 2010 12:57:43 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       lkml <linux-kernel@vger.kernel.org>,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 08/33] Removing dead SA1101
In-reply-to: <7488ec29cdb90212e965f6cd1173141c576c0955.1277911346.git.siccegge@cs.fau.de>
Message-id: <alpine.LFD.2.00.1006301255260.24097@xanadu.home>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <7488ec29cdb90212e965f6cd1173141c576c0955.1277911346.git.siccegge@cs.fau.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Christoph Egger wrote:

> SA1101 doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Acked-by: Nicolas Pitre <nico@fluxnic.net>

> ---
>  arch/arm/mach-sa1100/include/mach/SA-1101.h  |  925 --------------------------
>  arch/arm/mach-sa1100/include/mach/hardware.h |    4 -
>  2 files changed, 0 insertions(+), 929 deletions(-)
>  delete mode 100644 arch/arm/mach-sa1100/include/mach/SA-1101.h
> 
[...]


Nicolas
