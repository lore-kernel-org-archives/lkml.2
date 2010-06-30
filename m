Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0F3Oky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:40:54 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:49121 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0F3Okx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:40:53 -0400
Date: Wed, 30 Jun 2010 15:40:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexandre Julliard <julliard@winehq.org>,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Prasad <prasad@linux.vnet.ibm.com>,
       "2 . 6 . 33 . x 2 . 6 . 34 . x" <stable@kernel.org>
Subject: Re: [GIT PULL] x86 breakpoint regression fix
In-Reply-To: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.00.1006301535480.13070@eddie.linux-mips.org>
References: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Frederic Weisbecker wrote:

>     - icebp/int01 trap. This instruction (0xf1) is undocumented and
>       generates an int 1 exception. Unlike single step through TF
>       flag, it doesn't set the single step origin of the exception
>       in dr6.

 Not quite completely undocumented, but a bit obscure indeed.  GDB calls 
this instruction ICEBP and some Intel sources -- INT1.  It's been around 
for a while (at least since 80286) and is mostly used by in-circuit 
emulators (hence the name GDB uses).

  Maciej
