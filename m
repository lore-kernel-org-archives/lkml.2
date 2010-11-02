Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826Ab0KBIak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 04:30:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37335 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0KBIab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JONyt49AjIag3WnsFXG2b0Y5pMWjuTx83jXgsas5rILwXd9qF+QlaTEErcV3zWHLhj
         lLeVBKtN2DxWje1QOOMCVYGD9VQnPE3/n5Zqhh/STS7iQ38t32Dtmdw0E4lT9w2o0LXp
         HAFDRdRzzCeTwSM+yTu/CF+hwceRhDvVvfTQg=
MIME-Version: 1.0
In-Reply-To: <1288538943.19875.1402847217@webmail.messagingengine.com>
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com>
	<20101025140218.5092.74117.stgit@warthog.procyon.org.uk>
	<28707.1288018465@redhat.com>
	<4CC5B8D3020000780001EFB4@vpn.id2.novell.com>
	<1288538943.19875.1402847217@webmail.messagingengine.com>
Date: Tue, 2 Nov 2010 16:30:29 +0800
Message-ID: <AANLkTimO5bkya9-ucz0kxsW=cNX5FjJi0zQPsRVAycQ8@mail.gmail.com>
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h numbers
 in brackets
From: Ming Lei <tom.leiming@gmail.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@osdl.org,
        David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/31 Alexander van Heukelum <heukelum@fastmail.fm>:
> In file included from /home/src/linux/linux-2.6/arch/x86/include/asm/suspend_32.h:10,
>                 from /home/src/linux/linux-2.6/arch/x86/include/asm/suspend.h:2,
>                 from /home/src/linux/linux-2.6/arch/x86/kernel/asm-offsets_32.c:21,
>                 from /home/src/linux/linux-2.6/arch/x86/kernel/asm-offsets.c:2:
> /home/src/linux/linux-2.6/arch/x86/include/asm/i387.h: In function ‘irq_ts_save’:
> /home/src/linux/linux-2.6/arch/x86/include/asm/i387.h:325: error: implicit declaration of function ‘kernel_locked’
> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1

This also touches me too on .37-rc1, any patch for the compile failure?

thanks,
-- 
Lei Ming
