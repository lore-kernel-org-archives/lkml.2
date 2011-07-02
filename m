Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1GBLVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 07:21:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1GBLVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 07:21:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 1/2] asm-generic: adapt delay.h to common implementation
Date: Sat, 2 Jul 2011 13:21:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        hans-christian.egtvedt@atmel.com, lethal@linux-sh.org
References: <1309600754-21217-1-git-send-email-jonas@southpole.se>
In-Reply-To: <1309600754-21217-1-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021321.10786.arnd@arndb.de>
X-Provags-ID: V02:K0:jY0HV4f2Tw3VZNEhV6Gjsrk0doMej16go0jfecJXn5O
 oo93z/zZyqqV0a5aHdaIkTBBgXAHMBzEcS2Hh3qNDsQSkq8yfj
 cv1Qcg1DUoeIbXGC3ZcFqzkAy4brCuPJ+h93DYnq+rNu42eee+
 Ona457f1HNAGvoEzhjH522K5Hb+8IeutaEDk7xl31JzhRYF4mK
 BF984JeDu9Bt9h4cNufaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011 11:59:13 Jonas Bonn wrote:
> 
> Several architectures are using a common delay.h implementation that
> appears to have originated with the x86 architecture.  This common
> implementation is a bit fuller than the current asm-generic version
> and has some compile-time checks that should be interesting for all
> architectures.
> 
> This patch takes the common delay.h version and replaces the rather
> trivial asm-generic version with it.  As no architecture was actually
> using asm-generic/delay.h, this change is rather innocuous; it will,
> however, allow us to switch at least four architectures over to using
> the asm-generic version.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>

Very nice. Do you want to keep that in your own tree for your convenience,
and merge it along with your architecture, or do you prefer me to
take them into the asm-generic tree?

If you want to add them to your tree, please add my

Acked-by: Arnd Bergmann <arnd@arndb.de>
