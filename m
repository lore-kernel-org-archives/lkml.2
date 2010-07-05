Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab0GEIaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:30:21 -0400
Received: from pegase1.c-s.fr ([194.2.40.7]:56791 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab0GEIaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:30:17 -0400
X-Greylist: delayed 2692 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jul 2010 04:30:17 EDT
Message-ID: <4C318D87.1010306@c-s.fr>
Date: Mon, 05 Jul 2010 09:45:11 +0200
From: LEROY Christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.34: arch/powerpc/sysdev/micropatch.c not compiling
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When activating micropatch option, the kernel does not compile.

It looks like a spi_t is not defined anywhere.

CC arch/powerpc/sysdev/micropatch.o
arch/powerpc/sysdev/micropatch.c: In function ‘cpm_load_patch’:
arch/powerpc/sysdev/micropatch.c:629: erreur: expected ‘=’, ‘,’, ‘;’, 
‘asm’ or ‘__attribute__’ before ‘*’ token
arch/powerpc/sysdev/micropatch.c:629: erreur: ‘spp’ undeclared (first 
use in this function)
arch/powerpc/sysdev/micropatch.c:629: erreur: (Each undeclared 
identifier is reported only once
arch/powerpc/sysdev/micropatch.c:629: erreur: for each function it 
appears in.)
cc1: warnings being treated as errors
arch/powerpc/sysdev/micropatch.c:630: erreur: ISO C89 interdit les 
mélanges de déclarations et de code
arch/powerpc/sysdev/micropatch.c:671: erreur: ‘spi_t’ undeclared (first 
use in this function)
arch/powerpc/sysdev/micropatch.c:671: erreur: expected expression before 
‘)’ token
make[1]: *** [arch/powerpc/sysdev/micropatch.o] Erreur 1
make: *** [arch/powerpc/sysdev] Erreur 2

Regards

