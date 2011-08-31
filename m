Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1HaOJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:09:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1HaOJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:09:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 22/35] Hexagon: Add locking types and functions
Date: Wed, 31 Aug 2011 16:09:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190801.806746182@codeaurora.org>
In-Reply-To: <20110830190801.806746182@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311609.49361.arnd@arndb.de>
X-Provags-ID: V02:K0:ke4a7N7CBeEMULxUqAe5qQMr42q7l9xYWOJafItbMY4
 TZCa60ZWE9NSCdCzqyPjmEdJ12YHnxFQ2ggQDw7Dvm1KZOqtgg
 kjaa5h9mgdKi2RrTV3+DDdQo0MOhPHJFu82gDJ6iOzbjEQ8Ei1
 /6hr6IBk6frTdLopMfZh6LZNje5TAlQfAMieufMJchogTnd57/
 YJVK8HZQqMnIh7PtKwFV3KH1rZOz4K5yLBgioh2YFCO8vwfrkD
 at4VDeIou1wL6XUwdcEmzwQ8IncVYCz358Vj0BL++xOv1o4eO8
 yAhbEkEl+oui7O874IGfxQd73umcexUX6uBq0nrex8rnMEliv5
 nehvCFIjPcBE26QGmIwQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> We pretty much just reused the PPC version of rwsem.h.  Spinlocks use ll/sc.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> 
> ---
>  arch/hexagon/include/asm/rwsem.h          |  132 +++++++++++++++++++++
>  arch/hexagon/include/asm/spinlock.h       |  186 ++++++++++++++++++++++++++++++
>  arch/hexagon/include/asm/spinlock_types.h |   42 ++++++
>  3 files changed, 360 insertions(+)

If you have reused an existing version of the rwsem.h file, please move that
into asm-generic and change powerpc and hexagon to just use it from there.

	Arnd
