Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2FRUfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab2FRUfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:35:20 -0400
Message-ID: <4FDF90FE.1050809@redhat.com>
Date: Mon, 18 Jun 2012 17:35:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: Build regressions/improvements in v3.5-rc3
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org> <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com> <20120618152758.3a0a28c7f68615e9e2599ee3@freescale.com>
In-Reply-To: <20120618152758.3a0a28c7f68615e9e2599ee3@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-06-2012 17:27, Kim Phillips escreveu:
> On Sun, 17 Jun 2012 21:56:59 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
>>    + drivers/edac/mpc85xx_edac.c: error: too few arguments to function
>> 'edac_mc_alloc':  => 983:90
>>
>> powerpc-randconfig
> 
> fixed in linux-next commit b9bc5dd, should have been upstreamed by
> now [1] - Mauro?

Just sent it a few mins ago. I was waiting for Linus to return back 
from his trip.

Regards,
Mauro

> 
> Kim
> 
> [1] http://marc.info/?l=linux-edac&m=133942731507920&w=2
> 


