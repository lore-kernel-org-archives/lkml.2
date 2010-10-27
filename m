Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab0J0Nqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:46:38 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:45543 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab0J0Nq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:46:26 -0400
X-Greylist: delayed 776 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Oct 2010 09:46:26 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201010271333.o9RDXTsl009137@clem.clem-digital.net>
Subject: 2.6.36-git10 fails compile -- iomap32.c (i386,UP)
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Wed, 27 Oct 2010 09:33:29 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi: 

  CC      arch/x86/mm/iomap_32.o
arch/x86/mm/iomap_32.c: In function 'kmap_atomic_prot_pfn':
arch/x86/mm/iomap_32.c:64: error: implicit declaration of function 'kmap_atomic_idx_push'
arch/x86/mm/iomap_32.c: In function 'iounmap_atomic':
arch/x86/mm/iomap_32.c:101: error: implicit declaration of function 'kmap_atomic_idx_pop'
make[2]: *** [arch/x86/mm/iomap_32.o] Error 1
make[1]: *** [arch/x86/mm] Error 2
make: *** [arch/x86] Error 2

-- 
Pete Clements 
