Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab2BNIKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 03:10:40 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43146 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756332Ab2BNIKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 03:10:38 -0500
Date: Tue, 14 Feb 2012 10:10:30 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Yang Bai <hamo.by@gmail.com>
cc: cl@linux-foundation.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] slab: warning if total alloc size overflow
In-Reply-To: <CAO_0yfPtibyYKZWtf0y3nFaijcuEKZbejaWsOFebrEinv_O0_Q@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1202141009130.3795@tux.localdomain>
References: <1329204499-2671-1-git-send-email-hamo.by@gmail.com> <alpine.LFD.2.02.1202140929040.2721@tux.localdomain> <CAO_0yfPtibyYKZWtf0y3nFaijcuEKZbejaWsOFebrEinv_O0_Q@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Yang Bai wrote:
> I did not find anything like SLAB_OVERFLOW using grep. Could you
> explain it more in detail?

You should add a new config option to lib/Kconfig.debug and wrap the debug 
check with it.

 			Pekka
