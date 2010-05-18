Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0ERLFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:05:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40742 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0ERLFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k2t509FbzVeMuYIRcLKCNySFOLs6yDi4nYBXSwlqwxb8TA6iOteiIjBdP/QnZDSKc3
         o7iygxU8BVImyvhtGp+qRZPVUxIzFRSR6K3DsVOgs3dWYHjVDIORTS9K40sOyICisVJm
         QzIcSX+JpIvZbvNaOn2L+wHxb26yygez/MArs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinIVjwrQ9gza2FIvZN5w4nm8ZjSUe836oRmWYG7@mail.gmail.com>
References: <20100518092532.GA3050@linux-sh.org>
	 <AANLkTim6t8oG-vdLKE918Sd2TFKJpSf5Bw2PTtSsD_Fh@mail.gmail.com>
	 <20100518101500.GA3156@linux-sh.org>
	 <AANLkTinIVjwrQ9gza2FIvZN5w4nm8ZjSUe836oRmWYG7@mail.gmail.com>
Date: Tue, 18 May 2010 20:05:44 +0900
Message-ID: <AANLkTindMQ3Clk_qVnwUNYbbWcXjsUyyy4fQsjdDflFt@mail.gmail.com>
Subject: Re: [GIT PULL] sh updates for 2.6.35-rc1
From: Magnus Damm <magnus.damm@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

On Tue, May 18, 2010 at 7:51 PM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hmm, so still it is between ARM and SH, so better option will be :
>
> include/linux/sh_clk.h -> include/sh/clk.h
> include/linux/sh_dma.h -> include/sh/dma.h
> include/linux/sh_intc.h -> include/sh/intc.h
>
> So when arm files will come then, then we can make it like this :
>
> include/arm/clk.h
> include/arm/dma.h
> include/arm/intc.h
>
> So user will program like this :
>
> #include <arm/dma.h>
> #include <sh/dma.h>

Right now the SH code does

#include <linux/sh_intc.h>

and the ARM code does

#include <linux/sh_intc.h>

Hope this clarifies!

/ magnus
