Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab0J0OTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:19:25 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43253 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0J0OTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:19:21 -0400
Subject: Re: 2.6.36-git10 fails compile -- iomap32.c (i386,UP)
From: Peter Zijlstra <peterz@infradead.org>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <201010271333.o9RDXTsl009137@clem.clem-digital.net>
References: <201010271333.o9RDXTsl009137@clem.clem-digital.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Oct 2010 16:19:09 +0200
Message-ID: <1288189149.15336.1907.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 09:33 -0400, Pete Clements wrote:
> Fyi: 
> 
>   CC      arch/x86/mm/iomap_32.o
> arch/x86/mm/iomap_32.c: In function 'kmap_atomic_prot_pfn':
> arch/x86/mm/iomap_32.c:64: error: implicit declaration of function 'kmap_atomic_idx_push'
> arch/x86/mm/iomap_32.c: In function 'iounmap_atomic':
> arch/x86/mm/iomap_32.c:101: error: implicit declaration of function 'kmap_atomic_idx_pop'
> make[2]: *** [arch/x86/mm/iomap_32.o] Error 1
> make[1]: *** [arch/x86/mm] Error 2
> make: *** [arch/x86] Error 2


http://lkml.org/lkml/2010/10/27/127
