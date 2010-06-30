Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab0F3WXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:23:10 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:38459 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0F3WXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:23:08 -0400
Date: Wed, 30 Jun 2010 23:23:07 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexandre Julliard <julliard@winehq.org>,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Prasad <prasad@linux.vnet.ibm.com>,
       "2 . 6 . 33 . x 2 . 6 . 34 . x" <stable@kernel.org>
Subject: Re: [GIT PULL] x86 breakpoint regression fix
In-Reply-To: <20100630190405.GB5243@nowhere>
Message-ID: <alpine.LFD.2.00.1006302315420.13070@eddie.linux-mips.org>
References: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com> <alpine.LFD.2.00.1006301535480.13070@eddie.linux-mips.org> <20100630190405.GB5243@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Frederic Weisbecker wrote:

> Right, in fact it was quite easy to find any documentation about it, it's
> just officially undocumented.

 I think it's simply not a part of the architecture.  IOW they are free to 
remove it at any time, though most likely it will be kept forever.  It's 
not like rocket science or whatever else to be kept hidden -- "everybody" 
knows this instruction (myself for at least 15 years).  That's stuff like 
FFREEP, etc. ;)

  Maciej
