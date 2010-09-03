Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0ICIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:06:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab0ICIGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:06:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C809B63.2040802@snapgear.com>
References: <4C809B63.2040802@snapgear.com> <4C804F3A.8020001@snapgear.com> <19747.1283422807@redhat.com> <20100902102203.19806.39028.stgit@warthog.procyon.org.uk> <7077.1283496259@redhat.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix M68K irqflags
Date: Fri, 03 Sep 2010 09:05:48 +0100
Message-ID: <13782.1283501148@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer <gerg@snapgear.com> wrote:

> > Unfortunately, I don't have a binutils that can handle the funny Coldfire
> > instructions.  Can you point me at a Coldfire toolchain?
> 
> This is what I currently use:
> 
> http://www.uclinux.org/pub/uClinux/m68k-elf-tools/tools-20080626/m68k-uclinux-tools-20080626.sh
> 
> Its just a binutils-2.18 and gcc-4.2.4 configured for m68k-uclinux
> target.

With this toolchain and the m68knommu defconfig, the asm errors are now gone,
but I see the following link error:

/usr/local/bin/m68k-uclinux-ld.real: error: no memory region specified for loadable section `.data..shared_aligned'

I don't see any errors or warnings concerning THREAD_SIZE.

David
