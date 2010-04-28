Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0D1Ndh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:33:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0D1Ndf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:33:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Fritzsche <peter.fritzsche@gmx.de>
Subject: Re: [PATCH 2/2] asm-generic: Don't warn that atomic_t is only 24 bit
Date: Wed, 28 Apr 2010 15:33:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>
References: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de> <1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de>
In-Reply-To: <1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004281533.29327.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Xwn5/e3Dq+1cxf3qd9stmbBGA95AsTrVN+vN
 KhWbv2mjStAdDQNBOMojw7UKlSqA7j7nq0rrjpA+88ZMA8LWBn
 OCOIbpj/WeRpoj0r8mYhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010, Peter Fritzsche wrote:
> 32-bit Sparc used to only allow usage of 24-bit of it's atomic_t type.
> This was corrected with linux 2.6.3 when Keith M Wesolowski changed the
> implementation to use the parisc approach of having an array of
> spinlocks to protect the atomic_t.
> 
> These warnings were also removed from the sparc implementation when the
> new implementation was merged in BKrev:402e4949VThdc6D3iaosSFUgabMfvw,
> but the warning still remained in some other places without any
> 24-bit-only atomic_t implementation inside the kernel.
> 
> We should remove these warnings to allow users to rely on the full
> 32-bit range of atomic_t.
> 
> Signed-off-by: Peter Fritzsche <peter.fritzsche@gmx.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
