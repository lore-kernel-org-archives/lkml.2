Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0FGNSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:18:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0FGNSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:18:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Revert adding some arch-specific signal syscalls to <linux/syscalls.h>.
Date: Mon, 7 Jun 2010 15:18:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <201006071254.o57CsAwG002729@farm-0002.internal.tilera.com>
In-Reply-To: <201006071254.o57CsAwG002729@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006071518.34013.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19W+4cetv8v+N/VgbDoovo4a4w96b/NS+x/DHR
 Ijml++WJMk7qvJUemPxGffQEefH/uL8vUuQ1k3vCMgui19X/ye
 8+gfSU4L58+vIkHJW6j9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 June 2010, Chris Metcalf wrote:
> It turns out there is some variance on the calling conventions for
> these syscalls, and <asm-generic/syscalls.h> is already the mechanism
> used to handle this.  Switch arch/tile over to using that mechanism and
> tweak the calling conventions for a couple of tile syscalls to match
> <asm-generic/syscalls.h>.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Looks good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
