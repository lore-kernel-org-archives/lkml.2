Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0JPNr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:47:57 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56747 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab0JPNrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YIK7ILUcpT2KdAZfws/aj17Z5IkN0Qs0ELmb+EvHCtKXFJIA6a3FkL/DutyrfIAyO1
         WojeMemWu3Xc2zyQvH3b9NB5kXmUWeBw0pv5LswTtCu4EavQYpT+umDTSA1ov+Cya4bO
         L/DLLtYvZHh/+LBt0geYxlNSNPPE2YrLieZPM=
MIME-Version: 1.0
In-Reply-To: <m2aamepa5s.fsf@igel.home>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
	<201010151253.15653.arnd@arndb.de>
	<AANLkTi=cA=yf7NmPVKXaZdoTBYmwdmy_frk7b_feG-WG@mail.gmail.com>
	<m262x24j2y.fsf@igel.home>
	<AANLkTimHYYLZHOxgco3jotD7ikVhaPh8FVcSqeZwtrVc@mail.gmail.com>
	<AANLkTimtyW8AbOj+w=mjPbpP1j0LB9JXdo7cb=nQAXQ8@mail.gmail.com>
	<m2aamepa5s.fsf@igel.home>
Date: Sat, 16 Oct 2010 22:47:49 +0900
Message-ID: <AANLkTimB77RRcJfNcX-w7E+mKiKmNzR661SrP8G09y7A@mail.gmail.com>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/16 Andreas Schwab <schwab@linux-m68k.org>:
> Akinobu Mita <akinobu.mita@gmail.com> writes:
>
>> m68knommu is big-endian minixfs but m68k (mmu) is little-endian minixfs
>> if I read arch/m68k/include/asm/bitops_{mm,no}.h correctly.
>
> Don't be confused by ^16, this is for the 16bit/32bit indexing
> correction.  The nommu version uses big-endian 32bit indexing which yet
> another format.

Oh, I see. I misunderstood.

So we need a special handling for it to keep compatibility.
