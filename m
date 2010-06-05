Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0FETyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:54:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab0FETx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:53:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] zorro: BKL removal
Date: Sat, 5 Jun 2010 21:53:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <alpine.DEB.2.00.1006052121550.12934@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1006052121550.12934@ayla.of.borg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006052153.43062.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Fbq6nuOkHD0PkOUb5tMgCGG/ZbZd6Uqn+gOw
 Jy+BLj+mG0RYneVxHI06rmR8W9q45p1Bwp4Cs5+BFjLaW1Mt3Y
 91QZBgIrpWKGM8OPFP3aA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 June 2010, Geert Uytterhoeven wrote:
> Remove BKL use from proc_bus_zorro_lseek(), like was done for
> proc_bus_pci_lseek() a long time ago.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
