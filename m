Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2AQI27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:28:59 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:33506 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2AQI26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:28:58 -0500
Date: Tue, 17 Jan 2012 09:28:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] mips: remove custom BUILD_BUG()
Message-ID: <20120117082841.GA15499@linux-mips.org>
References: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com>
 <1322092017-21471-2-git-send-email-ddaney.cavm@gmail.com>
 <1326779572.2564.47.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326779572.2564.47.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 06:52:52AM +0100, Eric Dumazet wrote:
> Date:   Tue, 17 Jan 2012 06:52:52 +0100
> From: Eric Dumazet <eric.dumazet@gmail.com>
> To: David Daney <ddaney.cavm@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>, ralf@linux-mips.org,
>  linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Linus Torvalds
>  <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, DM
>  <dm.n9107@gmail.com>, David Howells <dhowells@redhat.com>, David Daney
>  <david.daney@cavium.com>
> Subject: [PATCH] mips: remove custom BUILD_BUG()
> Content-Type: text/plain; charset="UTF-8"
> 
> Commit 1399ff86f2a2b (kernel.h: add BUILD_BUG() macro) broke mips build
> 
> In file included from /opt/src/linux/arch/mips/include/asm/io.h:16:0,
>                  from /opt/src/linux/arch/mips/include/asm/page.h:54,
>                  from include/linux/serial.h:16,
>                  from include/linux/serial_core.h:23,
>                  from include/linux/serial_8250.h:14,
>                  from arch/mips/mti-malta/malta-platform.c:25:
> include/linux/kernel.h:717:0: error: "BUILD_BUG" redefined [-Werror]
> /opt/src/linux/arch/mips/include/asm/page.h:43:0: note: this is the
> location of the previous definition
> cc1: all warnings being treated as errors
> 
> Remove the conflicting mips macro.

See 63e9c4fd1c86e894e62aa3737427163d5fb01056 [MIPS: Remove temporary kludge
from <asm/page.h>] in linux-next.

  Ralf
