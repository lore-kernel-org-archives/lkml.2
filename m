Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0D1Qqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:46:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39887
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704Ab0D1Qqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:46:46 -0400
Date: Wed, 28 Apr 2010 09:46:52 -0700 (PDT)
Message-Id: <20100428.094652.22534047.davem@davemloft.net>
To: peter.fritzsche@gmx.de
Cc: arnd@arndb.de, mingo@elte.hu, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, mathieu.desnoyers@polymtl.ca,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       wesolows@foobazco.org
Subject: Re: [PATCH 2/2] asm-generic: Don't warn that atomic_t is only 24
 bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de>
References: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de>
	<1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Fritzsche <peter.fritzsche@gmx.de>
Date: Wed, 28 Apr 2010 13:10:36 +0200

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

Acked-by: David S. Miller <davem@davemloft.net>
