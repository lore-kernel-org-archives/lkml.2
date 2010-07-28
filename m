Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0G1SeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:34:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50297 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0G1SeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QekThpr/A2TferiIJJMAgKEjpmer71lFSjoZUMeMmQsOr0xkp58g7IjmE32vW1BZcB
         8CPG6Weey/XV6vk9I91oNFH9qYDydPUZ84IuGMVDbYiacqoqXehRB6OXURDw7ZFpcXZ6
         Y/PRAMSJr8fm1V2QPb1JKPbes6y+z1vbGtX6M=
MIME-Version: 1.0
In-Reply-To: <20100728182714.GA29232@merkur.ravnborg.org>
References: <20100728182523.GA29198@merkur.ravnborg.org> <20100728182714.GA29232@merkur.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 28 Jul 2010 14:32:49 -0400
Message-ID: <AANLkTinrO+aC7wC4UcyQPox0Wq_7F+ag_rQDqLG4zXaN@mail.gmail.com>
Subject: Re: [PATCH 1/3] kbuild: allow assignment to {A,C,LD}FLAGS_MODULE on 
	the command line
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 14:27, Sam Ravnborg wrote:
> --- a/arch/blackfin/Makefile
> +++ b/arch/blackfin/Makefile
> -CFLAGS_MODULE    += -mlong-calls
> -LDFLAGS_MODULE   += -m elf32bfin
> +KBUILD_CFLAGS_MODULE    += -mlong-calls
> +KBUILD_LDFLAGS_MODULE   += -m elf32bfin

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
