Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0EQQzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:55:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596Ab0EQQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:55:44 -0400
Date: Mon, 17 May 2010 09:52:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, hpet: Add reference to chipset erratum documentation
 for disable-hpet-msi-quirk
In-Reply-To: <20100517164324.GB10254@alberich.amd.com>
Message-ID: <alpine.LFD.2.00.1005170952080.4195@i5.linux-foundation.org>
References: <20100517164324.GB10254@alberich.amd.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Andreas Herrmann wrote:
> 
> (At the moment the "SB700 Family Product Errata" document is available
> at http://support.amd.com/us/Embedded_TechDocs/46837.pdf)

Ok, this is against x86 -tip, right? It doesn't apply for me, so I'll just 
assume I will get it through the normal x86 merge requests.

		Linus
