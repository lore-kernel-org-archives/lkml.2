Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab1EXXBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:01:32 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:59671 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1EXXBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:01:31 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
In-Reply-To: <BANLkTik7w0w_RFxVONwRx9zw48mk_E8N8Q@mail.gmail.com>
References: <1306269105.21443.20.camel@dan>
	 <BANLkTik7w0w_RFxVONwRx9zw48mk_E8N8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 19:01:22 -0400
Message-ID: <1306278082.1921.6.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This trick doesn't work as you may expect on 64-bit.  You are
> relocating the physical image of the kernel, but the kernel actually
> runs from a fixed virtual mapping.  This would require adding the
> relocation code that 32-bit uses, so the virtual address can be
> changed.
> 

Noted, thanks, I'll be sure to not waste my time when I start working on
64-bit.

-Dan

> --
> Brian Gerst


