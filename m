Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2BNHwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:52:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55811 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2BNHv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1202140929040.2721@tux.localdomain>
References: <1329204499-2671-1-git-send-email-hamo.by@gmail.com> <alpine.LFD.2.02.1202140929040.2721@tux.localdomain>
From: Yang Bai <hamo.by@gmail.com>
Date: Tue, 14 Feb 2012 15:51:39 +0800
Message-ID: <CAO_0yfPtibyYKZWtf0y3nFaijcuEKZbejaWsOFebrEinv_O0_Q@mail.gmail.com>
Subject: Re: [PATCH] slab: warning if total alloc size overflow
To: Pekka Enberg <penberg@kernel.org>
Cc: cl@linux-foundation.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 3:31 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Tue, 14 Feb 2012, Yang Bai wrote:
>
> Did you check how much kernel text size increases? I'm pretty sure we'd need
> to wrap this with CONFIG_SLAB_OVERFLOW ifdef.
>
>                        Pekka

Hi Pekka,

I did not find anything like SLAB_OVERFLOW using grep. Could you
explain it more in detail?

-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33
