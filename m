Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0CXKy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:54:57 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56388 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab0CXKyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:54:55 -0400
Date: Wed, 24 Mar 2010 11:54:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for 2.6.34-rc2
Message-ID: <20100324115451.7eed9046@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100323095146.316a9487@mschwide.boeblingen.de.ibm.com>
References: <20100323095146.316a9487@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, 23 Mar 2010 09:51:46 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> a few bug fixes for s390, please pull from 'for-linus' branch of
> 
> 	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus
> 
> to receive the following updates:
> 
> Christian Borntraeger (1):
>       [S390] system.h: Fix compile error for 1 and 2 byte cmpxchg
> 
> Hans-Joachim Picht (1):
>       [S390] fix broken proc interface for sclp_async
> 
> Heiko Carstens (2):
>       [S390] smp: fix lowcore allocation
>       [S390] sclp: avoid 64 bit division
> 
> Martin Schwidefsky (1):
>       [S390] fix boot failures with compressed kernels
> 
> Michael Holzheu (1):
>       [S390] zcore: CPU registers are not saved under LPAR
> 
> Stefan Haberland (1):
>       [S390] dasd: check tsb validity
> 
> Stefan Weinhuber (1):
>       [S390] dasd: fix alignment of transport mode recovery TCW

The patch "[S390] fix boot failures with compressed kernels" had a bug.
I have not seen the patches in your tree yet, so I've updated the
for-linus branch on git390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

