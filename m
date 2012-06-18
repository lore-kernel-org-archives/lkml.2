Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2FRUaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:30:07 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56886 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816Ab2FRUaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:30:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Izz1202hzz8275eh8275dha1495iz2dh2a8h668h839h944hd24he5bhf0ah)
Date: Mon, 18 Jun 2012 15:27:58 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: Build regressions/improvements in v3.5-rc3
Message-ID: <20120618152758.3a0a28c7f68615e9e2599ee3@freescale.com>
In-Reply-To: <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com>
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2012 21:56:59 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

>   + drivers/edac/mpc85xx_edac.c: error: too few arguments to function
> 'edac_mc_alloc':  => 983:90
> 
> powerpc-randconfig

fixed in linux-next commit b9bc5dd, should have been upstreamed by
now [1] - Mauro?

Kim

[1] http://marc.info/?l=linux-edac&m=133942731507920&w=2

