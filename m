Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2AYM0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:26:25 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55658 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702Ab2AYM0Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:26:24 -0500
MIME-Version: 1.0
X-Originating-IP: [46.30.80.210]
In-Reply-To: <20255.62146.305064.490693@pilspetsen.it.uu.se>
References: <CACcUPpa5FydvemAX7idTOi9dU3+UYs_cra_YNq1bbQc47jr0Yw@mail.gmail.com>
 <20255.62146.305064.490693@pilspetsen.it.uu.se>
From: Stefan Seidel <stefans@android-x86.org>
Date: Wed, 25 Jan 2012 13:26:02 +0100
X-Google-Sender-Auth: NbvmuJZ7Z4KtKm1wElbYZf-E6uY
Message-ID: <CACcUPpaCoDdOnmWxf0h4vJz-=SFDnOExiChVaJiqce+_204+2Q@mail.gmail.com>
Subject: Re: Emulating unsupported x86 opcodes in software
To: linux-kernel@vger.kernel.org
Cc: Mikael Pettersson <mikpe@it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 13:17, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Just two general comments, not specifically related to emulating SSE3:
>
> 1. Deploying the emulator from userspace would be preferable.  LD_PRELOAD a
>   library containing the SSE3 emulation and init code to set up a SIGILL
>   handler.  This solves all the ring 0 vs 3 problems and avoids needing
>   any kernel modifications.
Thanks for the hint. I knew that this would be a possiblity, but I
don't think it's wise or possible to run _every_ binary that could
possibly be started on the machine with this technique - hence the
kernel integration.

> 2. It's not always the case that new instructions in later generation x86
>   processors trap in earlier generation processors.  E.g., several years
I think that's not a problem in the processor generation I target. The
said emulation has been used successfully on a lot of machines running
MacOS X, and this included the use of heavy multi-media apps which
actually use these intructions a lot.

Stefan
