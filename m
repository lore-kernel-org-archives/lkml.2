Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1FPMyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:54:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1FPMys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:54:48 -0400
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201105211910.26025.arnd@arndb.de>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
	 <201105211910.26025.arnd@arndb.de>
Content-Type: text/plain
Organization: Red Hat, Inc
Date: Thu, 16 Jun 2011 08:54:31 -0400
Message-Id: <1308228871.2153.109.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 19:10 +0200, Arnd Bergmann wrote:
> - Do not use __raw_readl/__raw_writel.
> 
> - Remove your IO_ADDRESS(), __REG, VULP, __SYSREG and __SYSREGA.
>   Replace them with proper use of ioremap().

If not __raw_readl/__raw_writel, what is the best way to access memory
mapped device registers on a bus that does the endian conversion in
hardware? I still need the endian conversion for devices on PCI bus.

--Mark


