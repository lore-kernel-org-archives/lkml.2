Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0FIBKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 21:10:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060Ab0FIBKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 21:10:40 -0400
Date: Tue, 8 Jun 2010 18:10:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [GIT PULL] x86 platform driver updates for 2.6.35-rc3
In-Reply-To: <20100608221901.GA25294@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1006081806040.4506@i5.linux-foundation.org>
References: <20100608221901.GA25294@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, Matthew Garrett wrote:
> 
> Some fixes for error paths, some config fixes, a minor update to hp-wmi 
> that deals with some annoying corner cases like AC adapter events being 
> interpreted as brightness down keystrokes and the Intel IPS driver. This 
> requires a small addition to the timer API but doesn't modify any 
> existing code. Should all be entirely low impact.

[ Very shortly after sending out an email about how most developers 
  probably don't end up reading much of lkml, and thus having missed all 
  the other threads on this subject ]

Everybody repeat after me: "After -rc2 I won't be taking patches or pull 
requests that aren't regression fixes or fixes to major bugs (oopses or 
security etc)".

See the -rc2 announcement, or any of (by now) roughly ten different 
threads on lkml and a couple of other mailing lists as response to pull 
requests etc ;^)

And yes, that very much does include new drivers. Especially if they end 
up affecting anything else (but in al honesty, I probably wouldn't take it 
now even if it was entirely standalone).

		Linus
