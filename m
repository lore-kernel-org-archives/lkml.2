Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1HQUls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:41:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1HQUjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 09/36] Hexagon: Add checksum functions
Date: Wed, 17 Aug 2011 21:40:09 +0200
Message-ID: <3022109.2FN82h7jRd@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163520.702483311@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.702483311@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DEzHVs29LuxWAVkGuU4KjSxnuGMmLCyRvW+6twFeZ4W
 LAd+NVYtOmiIYYnZ6G+Im/yE9m4wJViV23D7zyr1rmvxXybw1Q
 trVde+3/51GFFTa0cyIlhAgt/T8yXKZJLenYwqYJBSp9iU41hZ
 AEoetKi5Ybh1Kht2qtLJhiQ5Ot0EAzWGx6cg+HWcvS6P8icvwi
 Ryn0RQ1PYvuKlkdJdj/tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:06 Richard Kuo wrote:
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> 
> ---
>  arch/hexagon/include/asm/checksum.h   |   91 +++++++++++
>  arch/hexagon/include/asm/intrinsics.h |   26 +++
>  arch/hexagon/lib/checksum.c           |  269 ++++++++++++++++++++++++++++++++++
>  3 files changed, 386 insertions(+)

I think you should be able to use the generic implementation for the
bits that don't have hexagon specific assembly in them, to simplify the
code.

	Arnd
