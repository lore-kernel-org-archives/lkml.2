Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1LAWs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:48:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1LAWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:48:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>, NeilBrown <neilb@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic/unistd.h: support new process_vm_{readv,write} syscalls
Date: Thu, 01 Dec 2011 23:48:42 +0100
Message-ID: <12496289.FSF46xab1G@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <201112011815.pB1IFACw004908@farm-0002.internal.tilera.com>
References: <201112011815.pB1IFACw004908@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:smDPVehSJ+yMiLYJmFvqhrJSigCM+LUp2ylN3ZA0FGU
 V5ZHrZEoHjVyo7rGdpcrjLDmWqPPWzKfefp2m3/Yo1uq9Z7ETL
 Zx4niJjEcRM4bFm0i9YtuKGVScUxYBjbGLioLfvE6buNJvbFUG
 BN0Ip9AF3Z8JI8aE8E00rGL8cbqC7omazy/sEtsqG4yNGBfZ0u
 sXcFuJOl3pdSGSurd7EQ9nK/7R/Gblb9HVkHbJXIFBYPcBD08M
 GzGMxkmd7jtXplGhHfRlLfhS777hiLExNNnK2ZELPGWj5AhtZW
 ha9Nahsqs19I8VLy1HhQZ2VLcrlbalpUC498M6nQVXz4RT9wma
 o2Rx3JrLH13msFtbEJPs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 December 2011 12:54:31 Chris Metcalf wrote:
> Also prototype the "compat" functions so they can be referenced
> from C code.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  include/asm-generic/unistd.h |    8 +++++++-
>  include/linux/compat.h       |    9 +++++++++
>  2 files changed, 16 insertions(+), 1 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>

Chris, I don't have any other patches for asm-generic right now. Can you handle
this through the tile tree?

	Arnd
