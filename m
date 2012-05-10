Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761866Ab2EJWYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:24:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45270 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab2EJWX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <4430485.xEvkeJU8MB@donald.sf-tec.de>
References: <4430485.xEvkeJU8MB@donald.sf-tec.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 May 2012 15:23:37 -0700
X-Google-Sender-Auth: 3xtIj_Lmx2PWrdkyD1cWTp6fKcU
Message-ID: <CA+55aFwWrkmqFPW=hOPCiNDE9CGXrwk85W7-vt2Aeg5EC1MtJQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] PA-RISC: fix compile
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 1:50 PM, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
>
>  arch/parisc/include/asm/hardware.h |    3 ++-
>  arch/parisc/include/asm/page.h     |    6 ++++++
>  arch/parisc/include/asm/pdc.h      |    7 -------
>  arch/parisc/include/asm/pgtable.h  |    2 ++
>  arch/parisc/include/asm/spinlock.h |    2 ++
>  arch/parisc/kernel/pdc_cons.c      |    1 +
>  arch/parisc/kernel/time.c          |    1 +
>  drivers/parisc/sba_iommu.c         |    1 +
>  drivers/video/console/sticore.c    |    2 ++
>  include/asm-generic/getorder.h     |    2 +-
>  10 files changed, 18 insertions(+), 9 deletions(-)

The diffstat doesn't match the actual patches - there are no getorder.h changes.

Hmm?

                  Linus
